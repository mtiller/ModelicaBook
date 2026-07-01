// The structured figure contract. In production these are emitted by the specs
// DSL / _generate_casedata (MIC-87). Here they're committed for the slice.
import FO from './FO.json';
import FOE from './FOE.json';

export interface CaseVar {
  name: string;
  scale: number;
  legend: string;
  style: string;
}
export interface CaseParam {
  key: string;
  label: string;
  default: string | number;
  editable: boolean;
}
export interface CaseData {
  res: string;
  name: string;
  title: string;
  stopTime: number | null;
  tol: number;
  ncp: number;
  mods: Record<string, unknown>;
  params: CaseParam[];
  vars: CaseVar[];
}

export const cases: Record<string, CaseData> = {
  FO: FO as CaseData,
  FOE: FOE as CaseData,
};
