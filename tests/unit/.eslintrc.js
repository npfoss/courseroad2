module.exports = {
  "extends": [
    "plugin:vue/recommended",
    "standard"
  ],
  "rules": {
    "vue/max-attributes-per-line": [
      "error",
      {
        "singleline": 5,
        "multiline": {
          "max": 1,
          "allowFirstLine": false
        }
      }
    ],
    "semi": [
      2,
      "always",
      {
        "omitLastInOneLineBlock": true
      }
    ],
    "no-var": 0,
    "prefer-const": 1,
    "no-undef": 1
  },
  "overrides": [
    {
      "files": [
        "**/__tests__/*.{j,t}s?(x)"
      ],
      "env": {
        "jest": true
      }
    }
  ]
}
