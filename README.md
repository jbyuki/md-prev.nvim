## md-prev.nvim

A dependency-free plugin to preview markdown in the browser. It relies on the pure markdown-to-html provided by @mpeterv  [here](https://github.com/mpeterv/markdown). Also a big thanks to @realprogrammersusevim for giving me the idea in the first place with his plugin [md-to-html.nvim](https://github.com/realprogrammersusevim/md-to-html.nvim). To make the HTML look more modern, the github's flavored sylesheet is applied to the output available [here](https://github.com/sindresorhus/github-markdown-css). Note that an online connection is required.

**Important Note**: This an experiment more than anything. It shows what's possible with the Neovim API. It is not planned to develop this much further.

### Usage

* Start server with `require"md-prev".start_server(8087)`.
* Open a browser and navigate to `localhost:8087` and the current buffer will be rendered as HTML.

### Current limitations

* Very plain looking HTML
* Browser needs to be opened manually
* No way to refresh the page from Neovim. User has to refresh from browser each time to see changes.
