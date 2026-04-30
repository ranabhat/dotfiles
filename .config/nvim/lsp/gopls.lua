-- Install with: go install golang.org/x/tools/gopls@latest

---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	root_markers = { "go.mod", ".git" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		gopls = {
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
