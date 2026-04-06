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
├── pages/         # Landing pages, showcases, or standalone HTML pages
│   └── my-project.html
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
- `pages/`: shown under "Pages"; useful for landing pages, showcases, and standalone HTML pages

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

**Standalone pages**: If you want a custom project page, showcase, or standalone HTML page, place it in the `pages/` directory. It will automatically appear in the "Pages" section on your contributor homepage.

### Step 5: Submit a Pull Request

```bash
git add contributors/<your-username>/
git commit -m "add: <your-username>"
git push origin main
```

Then open your forked repository on GitHub, click **Contribute → Open pull request**, and submit a PR to this repository.

- **First PR**: An admin will review your content and update the CODEOWNERS file to assign your directory to you
- **Future updates**: You can modify your directory anytime — PRs that pass CI validation can be merged directly

## Permission System

**You can only modify your own directory. You cannot modify anyone else's content.** Three layers of defense ensure this:

### Layer 1: Branch Protection

The `main` branch is protected. No one (including admins) can push directly. All changes must go through a Pull Request.

### Layer 2: GitHub Actions Validation

Every PR triggers a CI check on all changed files. If you modified any file outside `contributors/<your-username>/`, CI fails and the PR cannot be merged.

For example, if user `alice` modifies `contributors/bob/README.md`, CI will report:

```
::error:: You can only modify files in contributors/alice/
Unauthorized changes:
  - contributors/bob/README.md
```

### Layer 3: CODEOWNERS

Each contributor's directory is registered with an owner in the [`CODEOWNERS`](CODEOWNERS) file. Changes to a directory require the owner's approval before the PR can be merged.

```
/contributors/alice/ @alice
/contributors/bob/   @bob
```

This means even if someone bypassed CI (theoretically impossible), no one can modify your content without your explicit approval.

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

- All text in **Markdown** format
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
🔒 Only you can edit your content — safe and controlled
🌐 All content is publicly accessible and permanently preserved

🔗 Website: https://liuzhao1225.github.io/remember-me.ai/
💻 GitHub: https://github.com/liuzhao1225/remember-me.ai

Fork → Write about yourself → Submit PR → Digital immortality. It's that simple.
```

---

**Remember me.**
