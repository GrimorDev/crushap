/**
 * Monochrome icon rendered via CSS mask so it inherits any color via currentColor/color prop.
 * Backed by the Lucide icon set copied into assets/icons/.
 */
export interface IconProps {
  /** Lucide icon file name without extension, e.g. "heart", "x", "message-circle" */
  name: 'arrow-left'|'bell'|'camera'|'check'|'chevron-left'|'flame'|'heart'|'image'|'map-pin'|'message-circle'|'search'|'send'|'settings'|'shield-check'|'sliders-horizontal'|'sparkles'|'star'|'undo-2'|'user'|'x'|'zap';
  size?: number;
  color?: string;
}
export function Icon(props: IconProps): JSX.Element;
