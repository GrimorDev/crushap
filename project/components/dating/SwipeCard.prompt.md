The core Discover-screen card: full-bleed photo, bottom scrim gradient, name/age/distance, bio and interest tags.
```jsx
<SwipeCard name="Mia" age={27} distance="3 km away" verified bio="Coffee snob, weekend hiker." tags={['Hiking','Coffee']} />
```
Pass `photo` as a rendered image / <image-slot> element for the full-bleed background; omitted, it falls back to a dark gradient.
