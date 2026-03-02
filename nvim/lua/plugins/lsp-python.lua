return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = { -- Или pyright, если вы его используете
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
            -- Указываем, что venv лежит в корне проекта
            venvPath = ".", 
            venv = ".venv",
          },
        },
      },
    },
  },
}
