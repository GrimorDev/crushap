export interface SwipeCardProps {
  name: string;
  age: number;
  distance?: string;
  verified?: boolean;
  bio?: string;
  photo?: React.ReactNode;
  tags?: string[];
}
export function SwipeCard(props: SwipeCardProps): JSX.Element;
