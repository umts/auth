export default {
  ignoreFiles: [
    "spec/dummy/app/assets/builds/*",
    "coverage/**/*",
    "node_modules/**/*",
    "spec/dummy/public/assets/**/*",
  ],
  extends: "stylelint-config-standard",
  overrides: [
    {
      files: ["**/*.scss"],
      extends: "stylelint-config-standard-scss",
    },
  ],
};
