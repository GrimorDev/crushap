export interface BottomNavProps {
  active?: 'discover'|'search'|'matches'|'chat'|'profile';
  onChange?: (key: string) => void;
}
export function BottomNav(props: BottomNavProps): JSX.Element;
