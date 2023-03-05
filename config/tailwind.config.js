const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['-apple-system', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'knoiz': {
          'noir': '#0A0A0A',
          'gris': '#141414',
          'violet-principale': '#5A189A',
          'violet-principale-hover': '#661CB0',
          'violet-secondaire': '#9D4EDD',
          'blanc': '#f4effa',
          'orange': '#FFBF00',
          'orange-hover': '#FFCC33',
          'rouge': '#F72C25',
          'rouge-hover': '#F8403A',
          'gris-text': '#ADADAD'
        },
        },
        screens: {
          'size1': '1700px',
          // => @media (min-width: 992px) { ... }
        },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}