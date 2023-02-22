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
        'spotify': {
          'vert': '#0EAD69',
          'vert-hover': '#11D07D',
          'gris': '#141414',
          'noir-2': '#0A0A0A',
          'noir': '#000000',
          'blanc': '#ECFDF6',
          'blanc-gris': '#CCCCCC',
          'orange': '#F9A62B',
          'orange-hover': '#F9B44D',
          'rouge': '#FF0035',
          'rouge-hover': '#FF1F4B',
          'text-gris': '#B8C2BE',
        },
        },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
