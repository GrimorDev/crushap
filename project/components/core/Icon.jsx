import React from 'react';
export function Icon({ name, size = 20, color = 'currentColor', style, ...rest }) {
  const url = `../../assets/icons/${name}.svg`;
  return React.createElement('span', {
    'aria-hidden': true,
    style: {
      display: 'inline-block', width: size, height: size, flexShrink: 0,
      backgroundColor: color,
      WebkitMaskImage: `url(${url})`, maskImage: `url(${url})`,
      WebkitMaskSize: 'contain', maskSize: 'contain',
      WebkitMaskRepeat: 'no-repeat', maskRepeat: 'no-repeat',
      WebkitMaskPosition: 'center', maskPosition: 'center',
      ...style
    },
    ...rest
  });
}
