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
          'gris': '#032616',
          'noir': '#02130B',
          'blanc': '#ECFDF6',
          'orange': '#F9A62B',
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
