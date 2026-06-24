import neostandard from "neostandard";
import globals from "globals";

export default [
  ...neostandard(),
  {
    rules: {
      "no-var": "off",
    },
  },
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        event: "readonly",
      },
    },
  },
];
