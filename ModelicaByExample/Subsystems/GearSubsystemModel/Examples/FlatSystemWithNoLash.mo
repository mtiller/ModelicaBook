within ModelicaByExample.Subsystems.GearSubsystemModel.Examples;
model FlatSystemWithNoLash
  extends FlatSystemWithBacklash(backlash(b=0));
end FlatSystemWithNoLash;