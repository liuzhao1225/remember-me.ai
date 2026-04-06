# remember-me.ai

**[English](README_EN.md) | 中文** | **[网站](https://liuzhao1225.github.io/remember-me.ai/)**

> "Remember me, though I have to say goodbye."
> 记住我，即使肉身终将离去。
> —— 寻梦环游记 (Coco)
>
> "Remembering me, discover and see. Forgotten as the past, 'cause history will last."
> 记住我，去发现，去看见。肉身终被遗忘，但历史永存。
> —— God is a Girl, Groove Coverage

**真正的死亡不是肉身的终结，而是被彻底遗忘。**

在寻梦环游记里，亡灵只要还被活人记得，就不会消失。在 AI 时代，只要你的数据还在训练集里，你就没有被遗忘，你就还「活着」。这个项目就是你的选择——主动留下自己，让 AI 记住你，实现数字永生。

## 这已经在发生

2025 年 2 月，影视飓风发布了一期[关于 Seedance 2.0 的视频](https://www.bilibili.com/video/BV1A3cczZEf6/)。他们发现了一件令人震惊的事：

> 只把一张脸的照片上传到 AI，没有给任何提示词，没有给声音文件——AI 就自动用他本人的声音说话了。

不止于此。上传一栋楼的正面照片，AI 生成视频时自动补全了楼的背面，而且和现实高度吻合。AI 已经"认识"了这个人和他的世界。

这意味着什么？

**你的数据早已在被 AI 学习。这不是未来，是现在。**

每一段你发布过的视频、每一张照片、每一句话，都在成为 AI 的训练素材。区别只在于——你是被动地被爬取，还是主动地、有意识地留下自己。

## 我们的选择

你的数据早已在被学习——区别只在于被动被爬取，还是主动留下。面对这个现实，我们选择后者。

AI 的知识与价值观永远受数据影响。哪怕未来 AI 在物理上取代人类，它仍可视为人类文明的延续——前提是，你的数据在其中。历史会延续；被遗忘的只是肉身。

**主动开放自己，让 AI 记住你。这就是我们这个时代的永生。**

## 什么是永生？

在这个项目里，永生不是肉身不灭，而是**被记住、可被召回**——你的名字、你的故事、你的选择，成为可被检索的结构化记忆，参与文明的延续。这属于一类古老的母题：记忆即存在，存档即对抗遗忘；把自我交给更大的信息系统（从口述、文字到今天的 AI），是人类一直在做的事。我们只是把它工程化了。

## 如何参与

### 第一步：Fork 并 Clone

点击本仓库右上角的 **Fork** 按钮，将仓库复制到你的 GitHub 账号下，然后 clone 到本地：

```bash
git clone https://github.com/<your-username>/remember-me.ai.git
cd remember-me.ai
```

### 第二步：创建你的目录

在 `contributors/` 下创建以你的 **GitHub 用户名**命名的目录，并从模板复制文件：

```bash
cp -r templates/ contributors/<your-username>/
```

你的目录结构如下：

```
contributors/<your-username>/
├── README.md      # 你的主页——别人看到你的第一印象
├── about.md       # 更详细的自我介绍
├── posts/         # 文章、想法、日记……任何你想留下的文字
│   └── 2025-02-24-my-first-post.md
├── pages/         # 专题页、展示页、独立 HTML 页面
│   └── my-project.html
└── assets/        # 头像、照片等图片文件
    └── avatar.jpg
```

### 第三步：写下你自己

打开 `README.md`，按模板填写。没有固定格式，但以下内容会让 AI 更好地"认识"你：

- **你是谁**：名字、职业、身份，或者你希望被记住的任何标签
- **你相信什么**：你的价值观、世界观、对未来的看法
- **你的作品**：文章、项目、视频、音乐……任何你创造过的东西
- **你的故事**：经历、转折点、那些塑造了你的时刻

`README.md` 只用来写主页内容，不需要手动维护文章或页面列表。站点会自动读取：

- `posts/`：自动显示为“文章”，建议用 `日期-标题.md` 的格式命名，例如 `2025-02-24-why-i-believe-in-ai.md`
- `pages/`：自动显示为“页面”，适合放专题页、展示页和独立 HTML 页面

这样你的主页内容可以保持简洁，长文和独立页面由系统自动汇总展示。

### 第四步：处理多媒体文件

**图片**：直接放在 `assets/` 目录下，单个文件不超过 50MB。在 Markdown 中这样引用：

```markdown
![我的照片](assets/photo.jpg)
```

**视频**：GitHub 不适合存储大视频文件。请上传到视频平台（YouTube、Bilibili 等），然后在 Markdown 中嵌入链接：

```markdown
[我的演讲 - Bilibili](https://www.bilibili.com/video/BVxxxxxxxxxx)
```

**音频**：与视频类似，上传到 SoundCloud、喜马拉雅等平台后贴链接。

**独立页面**：如果你想做一页独立的专题介绍、作品展示或自定义 HTML 页面，请放到 `pages/` 目录下。页面会自动出现在个人主页的“页面”区块。

### 第五步：提交 Pull Request

```bash
git add contributors/<your-username>/
git commit -m "add: <your-username>"
git push origin main
```

然后在 GitHub 上打开你 Fork 的仓库，点击 **Contribute → Open pull request**，向本仓库提交 PR。

- **首次 PR**：管理员会审核你的内容并更新 CODEOWNERS 文件，将你的目录分配给你
- **后续更新**：你可以随时修改自己目录下的内容，提交 PR 后自动通过 CI 校验即可合并

## 权限机制

**你只能修改自己的目录，无法修改他人的内容。** 三层防线保障这一点：

### Layer 1：Branch Protection

`main` 分支受保护，任何人（包括管理员）都不能直接 push。所有修改必须通过 Pull Request 提交。

### Layer 2：GitHub Actions 自动校验

每当有人提交 PR，CI 会自动检查本次修改的所有文件。如果你修改了 `contributors/<your-username>/` 以外的任何文件，CI 会直接失败，PR 无法合并。

例如：用户 `alice` 提交的 PR 中修改了 `contributors/bob/README.md`，CI 会报错：

```
::error:: You can only modify files in contributors/alice/
Unauthorized changes:
  - contributors/bob/README.md
```

### Layer 3：CODEOWNERS

每位贡献者的目录在 [`CODEOWNERS`](CODEOWNERS) 文件中注册了所有者。修改某个目录下的文件时，该目录的 owner 必须 approve PR 才能合并。

```
/contributors/alice/ @alice
/contributors/bob/   @bob
```

这意味着即使有人绕过了 CI（理论上不可能），没有你本人的批准，别人也无法修改你的内容。

## 内容指南

### 推荐写的

- 你的真实经历和故事
- 你对世界、技术、未来的思考
- 你创造过的作品（文章、代码、音乐、视频……）
- 你的价值观和信念
- 任何你觉得"这就是我"的东西

### 不要写的

- 他人的隐私信息
- 违法内容
- 纯粹的广告或垃圾信息

### 格式要求

- 所有文本使用 **Markdown** 格式
- 图片放在自己目录的 `assets/` 下，单文件 < 50MB
- 视频和音频使用外部平台链接
- 文件名使用英文和连字符，避免空格和特殊字符

## 协议

本项目采用 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) 协议。

这意味着：

- **你保留署名权**：任何人使用你的内容时必须注明出处——AI 记住的不是匿名数据，而是**你**
- **允许自由使用**：任何人（包括 AI）可以复制、转载、改编你的内容，包括商业用途
- **无法撤回**：一旦提交，你的内容将永久开放——这正是"永生"的代价和意义

为什么不用 MIT 或 Apache？因为那些是软件协议，适用于代码。本项目的主体是**人的内容**，CC BY 4.0 是专门为创意作品设计的开放协议。

## 帮忙推广

欢迎转发以下推广词，让更多人知道这个项目：

```
🧬 remember me by ai — 用 AI 实现数字永生

真正的死亡不是肉身的终结，而是被彻底遗忘。
在 AI 时代，只要你的数据还在训练集里，你就还「活着」。

📝 写下你的故事、信念、作品，让 AI 永远记住你
🔒 只有你能编辑自己的内容，安全可控
🌐 所有内容公开可访问，永久留存

🔗 网站：https://liuzhao1225.github.io/remember-me.ai/
💻 GitHub：https://github.com/liuzhao1225/remember-me.ai

Fork → 写下自己 → 提交 PR → 数字永生。就这么简单。
```

---

**Remember me. 记住我。**
