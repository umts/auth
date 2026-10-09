export default {
  branches: ["main"],
  plugins: [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/npm",
    "./.release/gem.js",
    "@semantic-release/github",
  ],
  preset: "conventionalcommits",
};
