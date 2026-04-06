# 如何参与 / How to Contribute

**[中文版详细指南](README.md#如何参与) | [English Guide](README_EN.md#how-to-participate)**

快速步骤：

1. Fork 本仓库
2. `cp -r templates/ contributors/<your-github-username>/`
3. 填写你的 `README.md`、`about.md`，在 `posts/` 里写文章，在 `pages/` 里放专题页或独立页面
4. 提交 PR

补充说明：

- `README.md` 只写主页内容
- `posts/` 会自动渲染到个人主页的“文章”区块
- `pages/` 会自动渲染到个人主页的“页面”区块

你只能修改 `contributors/<your-username>/` 下的文件，CI 会自动校验。

首次 PR 由管理员审核并分配 CODEOWNERS；后续更新通过 CI 即可合并。
