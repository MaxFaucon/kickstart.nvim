local M = {}

M.get_config_template = function(connection_string)
  local config = {
    ['$schema'] = 'https://pg-language-server.com/latest/schema.json',
    linter = {
      enabled = true,
      rules = {
        recommended = true,
      },
    },
    typecheck = {
      enabled = true,
    },
    plpgsqlCheck = {
      enabled = true,
    },
    db = {
      connectionString = connection_string,
    },
  }

  return vim.json.encode(config)
end

return M
