# Copyright (c) 2011, Joerg Raedler (Berlin, Germany)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer. Redistributions in binary form must
# reproduce the above copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the
# distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

__version__='0.6'
__author__='Joerg Raedler (joerg@j-raedler.de)'
__license__='BSD License (http://www.opensource.org/licenses/bsd-license.php)'

import sys, math, numpy, scipy.io

# extract strings from the matrix
strMatNormal = lambda a: [''.join(s).rstrip() for s in a]
strMatTrans  = lambda a: [''.join(s).rstrip() for s in zip(*a)]
    
# sign = lambda x: cmp(x, 0)
sign = lambda x: math.copysign(1.0, x)


class DyMatFile:
    """A result file written by Dymola or OpenModelica"""

    def __init__(self, fileName):
        """Open the file fileName and parse contents"""
        self.fileName = fileName
        self.mat = scipy.io.loadmat(fileName, chars_as_strings=False)
        self._vars = {}
        self._blocks = []
        try:
            fileInfo = strMatNormal(self.mat['Aclass'])
        except KeyError:
            raise Exception('File structure not supported!')
        if fileInfo[1] == '1.1':
            if fileInfo[3] == 'binTrans':
                # usually files from openmodelica or dymola auto saved,
                # all methods rely on this structure since this was the only
                # one understand by earlier versions
                names = strMatTrans(self.mat['name']) # names
                descr = strMatTrans(self.mat['description']) # descriptions
                for i in range(len(names)):
                    d = self.mat['dataInfo'][0][i] # data block
                    x = self.mat['dataInfo'][1][i]
                    c = abs(x)-1  # column
                    s = sign(x)   # sign
                    if c:
                        self._vars[names[i]] = (descr[i], d, c, s)
                        if not d in self._blocks:
                            self._blocks.append(d)
                    else:
                        self._absc = (names[i], descr[i])
            elif fileInfo[3] == 'binNormal':
                # usually files from dymola, save as...,
                # variables are mapped to the structure above ('binTrans')
                names = strMatNormal(self.mat['name']) # names
                descr = strMatNormal(self.mat['description']) # descriptions
                for i in range(len(names)):
                    d = self.mat['dataInfo'][i][0] # data block
                    x = self.mat['dataInfo'][i][1]
                    c = abs(x)-1  # column
                    s = sign(x)   # sign
                    if c:
                        self._vars[names[i]] = (descr[i], d, c, s)
                        if not d in self._blocks:
                            self._blocks.append(d)
                            b = 'data_%d' % (d)
                            self.mat[b] = self.mat[b].transpose()
                    else:
                        self._absc = (names[i], descr[i])
            else:
                raise Exception('File structure not supported!')
        elif fileInfo[1] == '1.0':
            # files generated with dymola, save as..., only plotted ...
            # fake the structure of a 1.1 transposed file
            names = strMatNormal(self.mat['names']) # names
            self._blocks.append(0)
            self.mat['data_0'] = self.mat['data'].transpose()
            del self.mat['data']
            self._absc = (names[0], '')
            for i in range(1, len(names)):
                self._vars[names[i]] = ('', 0, i, 1)
        else:
            raise Exception('File structure not supported!')
    
            
    def blocks(self):
        """Returns the numbers of all data blocks.

        :Arguments:
            - None
        :Returns:
            - sequence of integers
        """
        return self._blocks

    def names(self, block=None):
        """Returns the names of all variables. If block is given, only variables of this 
        block are listed.

        :Arguments:
            - optional block: integer
        :Returns:
            - sequence of strings
        """
        if block is None:
            return self._vars.keys()
        else:
            return [k for (k,v) in self._vars.items() if v[1] == block]

    def data(self, varName):
        """Return the values of the variable.

        :Arguments:
            - varName: string
        :Returns:
            - numpy.ndarray with the values"""
        tmp, d, c, s = self._vars[varName]
        di = 'data_%d' % (d)
        dd = self.mat[di][c]
        if s < 0:
            dd = dd * -1
        return dd

    # add a dictionary-like interface
    __getitem__ = data

    def block(self, varName):
        """Returns the block number of the variable.

        :Arguments:
            - varName: string
        :Returns:
            - integer
        """
        return self._vars[varName][1]

    def description(self, varName):
        """Returns the description string of the variable.

        :Arguments:
            - varName: string
        :Returns:
            - string
        """
        return self._vars[varName][0]

    def sharedData(self, varName):
        """Return variables which share data with this variable, possibly with a different 
        sign.

        :Arguments:
            - varName: string
        :Returns:
            - sequence of tuples, each containing a string (name) and a number (sign)
        ."""
        tmp, d, c, s = self._vars[varName]
        return [(n,v[3]*s) for (n,v) in self._vars.items() if n!=varName and v[1]==d and v[2]==c]

    def size(self, blockOrName):
        """Return the number of rows (time steps) of a variable or a block.

        :Arguments:
            - integer (block) or string (variable name): blockOrName
        :Returns:
            - integer
        """
        try:
            b = int(blockOrName)
        except:
            b = self._vars[blockOrName][1]
        di = 'data_%d' % (b)
        return self.mat[di].shape[1]

    def abscissa(self, blockOrName, valuesOnly=False):
        """Return the values, name and description of the abscissa that belongs to a 
        variable or block. If valuesOnly is true, only the values are returned.

        :Arguments:
            - integer (block) or string (variable name): blockOrName
            - optional bool: valuesOnly
        :Returns:
            - numpy.ndarray: values or
            - tuple of numpy.ndarray (values), string (name), string (description)
        """
        try:
            b = int(blockOrName)
        except:
            b = self._vars[blockOrName][1]
        di = 'data_%d' % (b)
        if valuesOnly:
            return self.mat[di][0]
        else:
            return self.mat[di][0], self._absc[0], self._absc[1]

    def sortByBlocks(self, varList):
        """Sort a list of variables by the block number, return a dictionary whose keys 
        are the block numbers and the values are lists of names. All variables in one 
        list will have the same number of values.

        :Arguments:
            - list of strings: varList
        :Returns:
            - dictionary with integer keys and string lists as values 
        """
        vl = [(v, self._vars[v][1]) for v in varList]
        vDict = {}
        for bl in self._blocks:
            l = [v for v,b in vl if b==bl]
            if l:
                vDict[bl] = l
        return vDict

    def nameTree(self):
        """Return a tree of all variable names with respect to the path names. Path 
        elements are separated by dots. The tree will represent the structure of the 
        Modelica models. The tree is returned as a dictionary of dictionaries. The keys 
        are the path elements, values are sub-dictionaries or variable names.

        :Arguments:
            - None
        :Returns:
            - dictionary
        """
        root = {}
        for v in self._vars.keys():
            branch = root
            elem = v.split('.')
            for e in elem[:-1]:
                if not e in branch:
                    branch[e] = {}
                branch = branch[e]
            branch[elem[-1]] = v
        return root

    def getVarArray(self, varNames, withAbscissa=True):
        """Return the values of all variables in varNames combined as a 2d-array. If 
        withAbscissa is True, include abscissa's values first. 
        **All variables must share the same block!**

        :Arguments:
            - sequence of strings: varNames
            - optional bool: withAbscissa
        :Returns:
            - numpy.ndarray
        """
        # FIXME: check blocks!
        v = [numpy.array(self.data(n), ndmin=2) for n in varNames]
        if withAbscissa:
            v.insert(0, numpy.array(self.abscissa(varNames[0], True), ndmin=2))
        return numpy.concatenate(v, 0)

    def writeVar(self, varName):
        """Write the values of the abscissa and the variabale to stdout. The text format 
        is compatible with gnuplot. For more options use DyMat.Export instead.

        :Arguments:
            - string: varName
        :Returns:
            - None
        """
        d = self.data(varName)
        a, aname, tmp = self.abscissa(varName)
        print('# %s | %s' % (aname, varName))
        for i in range(d.shape[0]):
            print('%f %g' % (a[i], d[i]))


# for compatibility with old versions
DymolaMat = DyMatFile

