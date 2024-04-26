# Shell & Nautilus Scripts

A collection of shell and Nautilus scripts to enhance productivity on Linux. Includes utilities for manipulating PDFs and images, file management automation, and more. Integrates with Nautilus and Nemo file managers for easy access to scripts. Useful for streamlining workflows and adding functionality without installing new software. Beginner-friendly Bash scripts that work across common Linux distros like Ubuntu, Fedora, etc. Open source and customizable.

[![Hits](https://hits.sh/github.com/AhmedMohamedAbdelaty/Shell-Nautilus-Scripts.svg?style=for-the-badge&label=Views)](https://hits.sh/github.com/AhmedMohamedAbdelaty/Shell-Nautilus-Scripts/)

<div align="center">
    <img src="https://github.com/AhmedMohamedAbdelaty/Shell-Nautilus-Scripts/assets/73834838/7ce3e469-cb6b-4bb6-acad-5cfa9ccc4753" alt="a0d581666d26dd9c66bf8ed395cba948">
</div>

## Getting Started

#### you can use them directly from the terminal or from the file manager like Nautilus or Nemo

### Installing in nautilus file manager

```bash
git clone https://github.com/AhmedMohamedAbdelaty/Shell-Nautilus-Scripts ~/.local/share/nautilus/scripts
```

### Installing in nemo file manager

```bash
git clone https://github.com/AhmedMohamedAbdelaty/Shell-Nautilus-Scripts ~/.local/share/nemo/scripts
```

---

> [!NOTE]
> Some scripts are not mine.

Note: if some PDF scripts not working, it might be because ImageMagick security policy 'PDF' blocking conversion from PDF to images, to fix it, run this command:

```bash
sudo sed -i '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml
```

## Want to contribute? Great

<div align="center">
    <img src="https://github.com/AhmedMohamedAbdelaty/Shell-Nautilus-Scripts/assets/73834838/a75b5e6e-7f3e-4439-9e89-4abd9ff1881b" alt="gon-freecss-wondering">
</div>

- Fork the repo
- Create a new branch
- Commit your changes
- Push to the branch
- Create a new Pull Request

---
