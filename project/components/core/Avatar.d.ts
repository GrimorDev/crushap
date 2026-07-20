export interface AvatarProps {
  src?: string;
  name?: string;
  size?: 'sm'|'md'|'lg'|'xl';
  online?: boolean;
}
export function Avatar(props: AvatarProps): JSX.Element;
