return {
  name = 'Laravel Serve',
  condition = {
    callback = function()
      return vim.fn.filereadable 'artisan' == 1
    end,
  },
  builder = function()
    return {
      cmd = 'php artisan serve',
      cwd = vim.fn.getcwd(),
    }
  end,
}
