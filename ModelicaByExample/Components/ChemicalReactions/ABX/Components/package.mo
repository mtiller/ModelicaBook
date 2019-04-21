within ModelicaByExample.Components.ChemicalReactions.ABX;
package Components "Component models for chemical reactions"
  model 'A+B->X' "A+B -> X"
    extends Interfaces.Reaction;
  protected
    Interfaces.ConcentrationRate R = k*C[Species.A]*C[Species.B];
  equation
    consumed[Species.A] = R;
    consumed[Species.B] = R;
    produced[Species.X] = R;
  end 'A+B->X';

  model 'A+B<-X' "A+B <- X"
    extends Interfaces.Reaction;
  protected
    Interfaces.ConcentrationRate R = k*C[Species.X];
  equation
    produced[Species.A] = R;
    produced[Species.B] = R;
    consumed[Species.X] = R;
  end 'A+B<-X';

  model 'X+B->T+S' "X+B->T+S"
    extends Interfaces.Reaction;
  protected
    Interfaces.ConcentrationRate R = k*C[Species.B]*C[Species.X];
  equation
    consumed[Species.A] = 0;
    consumed[Species.B] = R;
    consumed[Species.X] = R;
  end 'X+B->T+S';
end Components;
