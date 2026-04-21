{ pkgs, lib, config, ... }:
let
  aura-theme = pkgs.vimUtils.buildVimPlugin {
    name = "aura-theme";
    src = pkgs.fetchFromGitHub {
      owner = "daltonmenezes";
      repo = "aura-theme";
      rev = "505b6e2f0229f2637e8f6eda621b6cab98a41a87";
      sha256 = "sha256-mIws/mbNsaevFfDSAj6n4qGVd8ZDPIsHkxY8Vpam7fM=";
    } + "/packages/neovim";
  };  

  flakePath = "${config.home.homeDirectory}/nixconf";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      wl-clipboard
      nixd
    ];
    extraConfig = ''
      set number 
      set relativenumber

      set undofile

      set ignorecase
      set smartcase

      set splitright
      set splitbelow

      set whichwrap+=h,l,<,>,[,]
      set scrolloff=5

      set wrap
      set linebreak
      set nolist

      set shiftwidth=2
      set tabstop=2
      set expandtab

      colorscheme aura-dark
    '';
    extraLuaConfig = ''
      -- Mini.pairs
      require('mini.pairs').setup()
  
      -- Mini.pick
      require('mini.pick').setup()

      vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<cr>', { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<cr>', { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<cr>', { desc = 'Find help' })

      -- nvim-cmp setup
      local cmp = require('cmp')
      
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body) -- Use built-in snippet expansion
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Show source in menu
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              buffer = '[Buffer]',
              path = '[Path]',
            })[entry.source.name]
            return vim_item
          end
        },
      })

      -- LSP 
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- nixd
      lspconfig.nixd.setup({
        capabilities = capabilities,
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            formatting = {
              command = { "nixfmt" }, 
            },
            options = {
              nixos = {
                expr = '(builtins.getFlake "${flakePath}").nixosConfigurations.chervil.options',
              },
              home_manager = {
                expr = '(builtins.getFlake "${flakePath}").homeConfigurations."etcvi@chervil".options',
              },
            },
          },
        },
      })

      -- marksman
      lspconfig.marksman.setup({
        capabilities = capabilities,
      })

      -- LSP keymaps (set on LspAttach)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

      -- Bullets.vim
      vim.g.bullets_enabled_file_types = {
        'markdown',
        'text',
        'gitcommit',
      }

      -- zk-nvim
      require('zk').setup({
        picker = "minipick",
      })

      vim.keymap.set('n', '<leader>zn', "<cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>", { desc = 'New note' })
      vim.keymap.set('n', '<leader>zo', '<cmd>ZkNotes<cr>', { desc = 'Open notes' })
      vim.keymap.set('n', '<leader>zt', '<cmd>ZkTags<cr>', { desc = 'Search tags' })
      vim.keymap.set('n', '<leader>zf', '<cmd>ZkNotes { match = { vim.fn.input("Search: ") } }<cr>', { desc = 'Find notes' })
      vim.keymap.set('v', '<leader>zf', ":'<,'>ZkMatch<cr>", { desc = 'Find notes matching selection' })

      -- Zen Mode
      require('zen-mode').setup({
        window = {
          backdrop = 0.7,
          width = 100,
          options = {
            number = false,
          },
        },
        plugins = {
          twilight = { enabled = true },
        },
        on_open = function(win)
          vim.opt.linebreak = true
          vim.opt.wrap = true
          vim.opt.breakat = ' \t'
        end,
      })

      -- Markview
      require('markview').setup({
        modes = { "n", "i", "no", "c" },
        hybrid_modes = { "i" },
        callbacks = {
          on_enable = function (_, win)
            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = "nc"
          end
        }
      })

      -- markdown-preview
      vim.g.mkdp_auto_close = 0       
      vim.g.mkdp_theme = 'dark'        
      vim.g.mkdp_browser = 'firefox'          
      vim.g.mkdp_refresh_slow = 1      

      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<cr>', { desc = 'Markdown preview open' })
      vim.keymap.set('n', '<leader>mc', '<cmd>MarkdownPreviewStop<cr>', { desc = 'Markdown preview close' })
      vim.keymap.set('n', '<leader>mt', '<cmd>MarkdownPreviewToggle<cr>', { desc = 'Markdown preview toggle' })

      -- Neorg
      require('neorg').setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
               notes = "~/notes",
              },
              default_workspace = "notes",
            },
          },
        },
      })

      -- Clipboard config
      vim.opt.clipboard = "unnamedplus"

      if os.getenv("WAYLAND_DISPLAY") then
        vim.g.clipboard = {
          name = 'wl-clipboard',
          copy = {
            ['+'] = 'wl-copy',
            ['*'] = 'wl-copy',
          },
          paste = {
            ['+'] = 'wl-paste --no-newline',
            ['*'] = 'wl-paste --no-newline',
          },
          cache_enabled = 0,
        }
        end
    '';
    plugins = with pkgs.vimPlugins; [
      # LSP
      nvim-lspconfig
      
      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      
      # UI
      which-key-nvim
      mini-nvim
      mini-pick
      markview-nvim
      conform-nvim
      aura-theme
      zen-mode-nvim
      twilight-nvim
      
      # Markdown/Notes
      zk-nvim
      neorg
      markdown-preview-nvim
      bullets-vim
      
      # Formatting
      vim-prettier
      
      # Treesitter
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          nix
	        markdown
	        html
	        css
	        bash
	      ]
      ))
    ];
  };

  home.packages = with pkgs; [
    zk
    marksman
    nixd  
  ];
}
