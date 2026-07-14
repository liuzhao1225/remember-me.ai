# remember-me.ai

**English | [中文](README.md)** | **[Website](https://liuzhao1225.github.io/remember-me.ai/)**

> "Remember me, though I have to say goodbye."
> Remember me, even when the body is gone.
> — Coco (2017)
>
> "Remembering me, discover and see. Forgotten as the past, 'cause history will last."
> Remember me — discover and see. The body is forgotten; history lasts.
> — God is a Girl, Groove Coverage

**True death is not the end of the body — it's being completely forgotten.**

In Coco, the dead stay as long as the living remember. In the age of AI, as long as your data remains in the training set, you are not forgotten. You are still "alive." This project is your choice — leave yourself behind deliberately, let AI remember you, and achieve digital immortality.

## This Is Already Happening

In February 2025, a Chinese tech YouTube channel published a [video about Seedance 2.0](https://www.bilibili.com/video/BV1A3cczZEf6/). They discovered something stunning:

> They uploaded only a photo of a face to the AI — no prompts, no voice samples — and the AI automatically spoke in that person's real voice.

It went further. When they uploaded a photo showing only the front of a building, the AI generated a video that panned around to show the back — and it matched reality. The AI already "knew" this person and their world.

What does this mean?

**Your data is already being learned by AI. This is not the future — it's the present.**

Every video you've posted, every photo, every sentence is becoming training data for AI. The only difference is whether you're passively scraped, or actively and consciously leaving yourself behind.

## Our Choice

Your data is already being learned — the only difference is whether you're scraped passively or leave yourself behind by choice. Facing that reality, we choose the latter.

AI's knowledge and values are always shaped by data. Even if AI one day replaces humanity in the physical world, it can still be a continuation of human civilization — as long as your data is in it. History lasts; what is forgotten is only the body.

**Open yourself up. Let AI remember you. This is immortality in our era.**

## What Is Immortality?

Here, immortality is not the body lasting forever — it's **being remembered and recallable**. Your name, your story, your choices become structured memory that can be retrieved and carried forward in civilization. That belongs to an old motif: memory is existence; the archive is a stand against oblivion. Handing the self over to a larger system — from orality and writing to today's AI — is what humans have always done. We're just making it concrete.

## How to Participate

### Step 1: Fork and Clone

Click the **Fork** button in the top-right corner to copy this repository to your GitHub account, then clone it locally:

```bash
git clone https://github.com/<your-username>/remember-me.ai.git
cd remember-me.ai
```

### Step 2: Create Your Directory

Create a directory under `contributors/` named after your **GitHub username**, and copy the template files:

```bash
cp -r templates/ contributors/<your-username>/
```

Your directory structure:

```
contributors/<your-username>/
├── README.md      # Your homepage — the first impression others see
├── about.md       # A more detailed self-introduction
├── posts/         # Articles, thoughts, journals — any writing you want to leave behind
│   └── 2025-02-24-my-first-post.md
├── pages/         # Markdown landing pages and showcases
│   └── my-project.md
└── assets/        # Avatar, photos, and other image files
    └── avatar.jpg
```

### Step 3: Write About Yourself

Open `README.md` and fill it in using the template. There's no rigid format, but the following will help AI "know" you better:

- **Who you are**: Name, profession, identity, or any label you want to be remembered by
- **What you believe**: Your values, worldview, thoughts on the future
- **Your work**: Articles, projects, videos, music — anything you've created
- **Your story**: Experiences, turning points, the moments that shaped you

Use `README.md` only for your homepage content. You do not need to manually maintain lists of articles or pages. The site will automatically read:

- `posts/`: shown under "Articles"; we recommend names like `date-title.md`, e.g. `2025-02-24-why-i-believe-in-ai.md`
- `about.md`: published as the contributor's About page
- `pages/`: shown under "Pages"; useful for Markdown landing pages and showcases

This keeps your homepage clean while letting the site automatically surface your longer writing and custom pages.

### Step 4: Handle Media Files

**Images**: Place them in the `assets/` directory, max 50MB per file. Reference them in Markdown like this:

```markdown
![My photo](assets/photo.jpg)
```

**Videos**: GitHub isn't suited for large video files. Upload to a video platform (YouTube, Bilibili, etc.) and embed the link in Markdown:

```markdown
[My Talk - YouTube](https://www.youtube.com/watch?v=xxxxxxxxxx)
```

**Audio**: Same as video — upload to SoundCloud, Spotify, etc., and paste the link.

**Standalone pages**: Use Markdown files in `pages/` for project pages and showcases. To prevent same-origin scripts and phishing, external contributions may not add custom HTML, SVG, or JavaScript files.

### Step 5: Submit a Pull Request

```bash
git add contributors/<your-username>/
git commit -m "add: <your-username>"
git push origin main
```

Then open your forked repository on GitHub, click **Contribute → Open pull request**, and submit a PR to this repository.

- **Every PR**: Path, file type, UTF-8, raw HTML, symlink, Jekyll build, and link checks run before maintainer review
- **Future updates**: You may update your directory at any time, but bots do not approve or merge contributor PRs

## Permission System

**External contributor PRs may only modify the directory matching the author's GitHub username.** Repository maintainers retain administrative access for site maintenance and security response.

### Layer 1: Branch Protection

The `main` branch uses a GitHub Ruleset requiring pull requests and status checks. Administrators retain bypass access only for emergency maintenance.

### Layer 2: GitHub Actions Validation

For external contributor PRs, CI requires every changed file to stay under `contributors/<your-username>/`. It also rejects symlinks, gitlinks, raw HTML, unsafe URLs, invalid encoding, and unsupported file types. A separate read-only workflow builds Jekyll and checks internal links without secrets.

For example, if user `alice` modifies `contributors/bob/README.md`, CI will report:

```
::error:: Every changed file must be under contributors/alice/
Unauthorized: contributors/bob/README.md
```

### Layer 3: Maintainer Review and CODEOWNERS

The repository's [`.github/CODEOWNERS`](.github/CODEOWNERS) requires maintainer review for all changes. Contributors cannot approve their own pull requests.

CI and maintainer review prevent external changes from entering `main` automatically. Maintainers can reject or revert policy violations and security issues.

## Content Guidelines

### What to Write

- Your real experiences and stories
- Your thoughts on the world, technology, and the future
- Work you've created (articles, code, music, videos…)
- Your values and beliefs
- Anything that makes you think "this is me"

### What Not to Write

- Other people's private information
- Illegal content
- Pure advertising or spam

### Format Requirements

- All text in **Markdown** format; raw HTML is not allowed in external contributions
- Images in your `assets/` directory, max 50MB per file
- Videos and audio via external platform links
- Filenames in English with hyphens, no spaces or special characters

## License

This project is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

This means:

- **You retain attribution**: Anyone using your content must credit you — AI remembers not anonymous data, but **you**
- **Free to use**: Anyone (including AI) may copy, share, and adapt your content, even commercially
- **Irrevocable**: Once submitted, your content is permanently open — this is both the cost and the meaning of "immortality"

Why not MIT or Apache? Those are software licenses, designed for code. This project is primarily about **human content**, and CC BY 4.0 is an open license specifically designed for creative works.

## Help Spread the Word

Feel free to share the following promotional copy:

```
🧬 remember me by ai — Digital immortality through AI

True death is not the end of the body — it's being completely forgotten.
In the age of AI, as long as your data remains in the training set, you are still "alive."

📝 Write your story, beliefs, and work — let AI remember you forever
🔒 Path validation, build checks, and human review protect contributions
🌐 All content is publicly accessible and permanently preserved

🔗 Website: https://liuzhao1225.github.io/remember-me.ai/
💻 GitHub: https://github.com/liuzhao1225/remember-me.ai

Fork → Write about yourself → Submit PR → Digital immortality. It's that simple.
```

---

**Remember me.**
