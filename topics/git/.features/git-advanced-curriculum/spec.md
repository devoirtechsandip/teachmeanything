# Specification: Git Advanced Curriculum (Modules 2–7)

## Gherkin Feature Specifications

### Feature: Complete 15-Lesson Git Mastery Track
  As a learner mastering Git from basic to advanced CLI
  I want a complete, progressive, 15-lesson interactive curriculum
  So that I can operate comfortably in production software engineering teams.

  Scenario: All lessons present and accessible
    Given the Git topic workspace at "topics/git/lessons"
    Then files "0001-why-git-and-the-snapshot-model.html" through "0015-under-the-hood-the-git-object-store.html" must exist
    And each lesson must implement the standard design system with sticky navigation, reading progress indicator, interactive simulator, and retrieval quizzes.

  Scenario: Companion quick-reference cards available
    Given the Git reference directory at "topics/git/reference"
    Then reference files "01-why-and-core-mental-model.html" through "15-git-object-store-internals.html" must exist
    And each reference card must provide actionable syntax cheat sheets and matrix tables.

  Scenario: Learning records milestone coverage
    Given the learning records directory at "topics/git/learning-records"
    Then learning records "0001-*.md" through "0008-*.md" must be tracked
    And each record must document evidence and pedagogical implications.

  Scenario: Zero broken links across distribution build
    Given the repository root build script "scripts/build-site.sh"
    When the build script is executed
    Then all links in "index.html" targeting Git lessons and references must exit with status code 0.
