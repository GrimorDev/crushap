export interface MatchOverlayProps {
  youPhoto?: string;
  matchPhoto?: string;
  matchName: string;
  onMessage?: () => void;
  onKeepSwiping?: () => void;
}
export function MatchOverlay(props: MatchOverlayProps): JSX.Element;
