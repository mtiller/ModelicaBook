import os, gettext

def create_gettext(module_name):
    _dir = os.path.abspath(os.path.dirname(__file__))
    locale_path = os.path.join(_dir, '..', '..', '..', 'locale')
    try:
        language = os.environ['BOOK_LANG']
        t = gettext.translation(module_name, locale_path, [language])
        _ = t.ugettext
    except Exception as err:
        _ = lambda x: x

    return _

def set_matplotlib():
    language = os.environ.get('BOOK_LANG')
    if language == 'cn':
        from matplotlib import rcParams
        rcParams['font.family'] = 'Droid Sans Fallback'
        rcParams['axes.unicode_minus'] = False
