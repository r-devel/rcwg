# Source for [R Contribution Site](https://github.com/forwards/rcontribution)

## Website structure

The top-level pages linked in the menu are in correspondingly named markdown files, e.g. 

| Menu item   | Markdown file | Relative URL |
|-------------|---------------|--------------|
| Home        | `index.md`    | `/`          |
| Slack Group | `slack.md`    | `/slack`     |

You can create sub-pages by creating a folder with an `index.md` file. Any further markdown pages within that folder will be sub-pages under that, e.g.

| Markdown file | Relative URL |
|---------------|---------------|
|`translating-r-to-your-language/index.md` | `/translating-r-to-your-language` |  
|`translating-r-to-your-language/prep.md` | `/translating-r-to-your-language/prep` |
  
## Basic editing

You can edit the markdown files on the `gh-pages` branch and the changes will be automatically deployed to the live site once the changes are committed. If you edit the files directly on GitHub using the browser editor, then you can use the Preview tab to check the formatting before committing.

## Substantial editing

If you are making substantial changes, e.g. adding a new page, or making changes that require collaborating editing/review before being pushed, create a branch from the gh-pages branch and make the changes there.

Any changes pushed to a different branch will not be automatically deployed to preview. so if the GitHub editor preview is not sufficient (i.e. you are doing more than editing a single page) it is best to clone the repo and make your changes locally.

### Previewing locally

To preview the site locally, you will need to install Jekyll, see https://jekyllrb.com/docs/ for installation instructions for common operating systems.

To build the site and make it available on a local server, run the following command in a terminal from the top level directory of the locally cloned repository (i.e. in the `rcontribution` folder).

```
bundle exec jekyll serve
```

If you use RStudio, you can open the `rcontribution.Rproj` project, open this `README.md` file and use `Ctrl/Cmd + Alt + Enter` to send the above line to the terminal.

Open http://localhost:4000 in your browser to preview the site. The site is repeatedly rebuilt, so if you make changes to the markdown files and save them, you should see the changes straight-away. Use `Ctrl/Cmd + C` to stop locally serving the site.

You will need to restart the server if you add/remove items from the menu.

### Editing the menu

To edit the menu you need to edit the `navigation` field of `_config.yml`.

To add a new page, add a new element with the title and URL of the page. Use the relative URL for pages in this repo, e.g.

```
  - title: Slack Group
    url: slack
```

Use the full URL for external pages, e.g. 

```
  - title: R Developer Page
    url: https://developer.r-project.org/
```  

## Website theme

This is a GitHub pages site, using the [modified minimal Jekyll theme](https://github.com/kbsezginel/gh-pages-template) by [kbsezginel](https://github.com/kbsezginel). The [theme documentation](https://kbsezginel.github.io/gh-pages-template/setup) provides instructions for initial setup and customization, which are probably not required for day-to-day editing.
