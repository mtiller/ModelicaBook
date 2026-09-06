// The structured figure contract consumed by <SimFigure> (data-case).
//
// Hand-written, NOT generated. The sibling *.json files are committed
// artifacts: they derive from text/results/ (DVC output + a containerised
// simulation run), so they cannot be rebuilt from a clean clone. This registry
// is therefore derived at build time from whatever case files are present,
// rather than being a generated list that can drift from — or be silently
// emptied independently of — the data it describes.
//
// tools/build-cases.mjs refreshes the *.json files after a DVC pull; it does
// not write this file.
export interface CaseVar { name: string; scale: number; legend: string; style: string }
export interface CaseParam { key: string; label: string; default: string | number; editable: boolean }
export interface CaseData {
  res: string; name: string; title: string;
  stopTime: number | null; tol: number; ncp: number;
  mods: Record<string, unknown>; params: CaseParam[]; vars: CaseVar[];
  ylabel?: string; legloc?: string; ncols?: number; type?: string;
}

const modules = import.meta.glob<{ default: CaseData }>('./*.json', { eager: true });

export const cases: Record<string, CaseData> = Object.fromEntries(
  // './FO.json' -> 'FO'
  Object.entries(modules).map(([p, m]) => [p.slice(2, -5), m.default]),
);
