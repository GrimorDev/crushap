export interface IconButtonProps {
  icon: string;
  size?: 'sm'|'md'|'lg';
  variant?: 'filled'|'outline'|'ghost'|'surface';
  label: string;
}
export function IconButton(props: IconButtonProps): JSX.Element;
