import re


def main():
    with open("main.tex") as f:
        main = f.read()

    with open("main.tex.tmp") as f:
        tmp = f.readlines()

    with open("main.tex.tmp", "w") as f:
        for line in tmp:
            match = re.match(r"\\hypertarget\{([^}]+)\}\{\}", line)
            if match:
                name = match.group(1)

                pattern = re.compile(
                    r"\\hypertarget\{" + re.escape(name) + r"\}\{%.*?\}\}", re.DOTALL
                )
                figure = pattern.search(main)
                if figure:
                    f.write(figure.group() + "\n")
                    continue

            f.write(line)


if __name__ == "__main__":
    main()
