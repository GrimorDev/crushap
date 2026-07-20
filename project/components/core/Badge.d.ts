export interface BadgeProps {
  children?: React.ReactNode;
  variant?: 'neutral'|'verified'|'premium'|'accent';
  icon?: React.ReactNode;
}
export function Badge(props: BadgeProps): JSX.Element;
