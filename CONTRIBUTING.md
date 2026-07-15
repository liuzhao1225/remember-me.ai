# 如何参与 / How to Contribute

**[中文版详细指南](README.md#如何参与) | [English Guide](README_EN.md#how-to-participate)**

快速步骤：

1. Fork 本仓库
2. `cp -r templates/ contributors/<your-github-username>/`
3. 填写你的 `README.md`、`about.md`，在 `posts/` 里写文章，在 `pages/` 里放 Markdown 专题页
4. 提交 PR

补充说明：

- `README.md` 只写主页内容
- `posts/` 会自动渲染到个人主页的“文章”区块
- `about.md` 会自动发布为“关于”页面
- `pages/` 中的 Markdown 会自动渲染到个人主页的“页面”区块
- 外部贡献不得包含原始 HTML、SVG、JavaScript、符号链接或 Git 子模块
- `assets/` 只接受 PNG、JPEG、GIF、WebP 和 AVIF 图片

外部贡献者只能修改 `contributors/<your-username>/` 下的文件，CI 会执行路径、内容、构建和链接校验。

所有 PR 都需要维护者审核；机器人不会自动批准或合并。
