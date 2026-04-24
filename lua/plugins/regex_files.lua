return {
  {
    "folke/snacks.nvim",
    keys = {
      --{
      --  "<leader><space>",
      --  function()
      --    require("config.regex_files").open()
      --  end,
      --  desc = "Regex Files",
      --},
      {
        "<leader>ff",
        function()
          require("config.regex_files").open()
        end,
        desc = "Regex Files",
      },
    },
    init = function()
      vim.api.nvim_create_user_command("RegexFiles", function()
        require("config.regex_files").open()
      end, { desc = "Search files by regex with Snacks picker" })
    end,
  },
}
