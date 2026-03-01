# Guidelines

## Checklists

### New Version Releasing

1. Ensure all tests pass on CI.
2. Update the version number in `immut.lua`.
3. Update the **Changelog** section in `README.md`.
4. Create a new rockspec file in `rockspecs`.
5. Commit the changes with a message like `vX.Y.Z`.
6. Push and merge the changes to the `main` branch.
7. Create the release on GitHub.
8. Upload the new package to LuaRocks.

### Adding a New Top-Level Function
1. Insert the new function into the `immut` table in `immut.lua`.
2. Create tests for the function in `develop/testing/function_name_tests.lua`.
3. Add the new test to `develop/all.lua`.
5. Document the function in the **Cheat Sheet** section of `README.md`.
6. Provide a description in the **Overview** section of `README.md`.
7. Describe the update in the **Changelog** section of `README.md`.
