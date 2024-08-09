import random
import os

def generate_random_docs():
    topics = [
        "Introduction",
        "Installation",
        "Usage",
        "Configuration",
        "Examples",
        "API Reference",
        "FAQ",
        "Troubleshooting",
        "Contributing",
        "License"
    ]

    with open('docs/random_docs.txt', 'w') as f:
        for topic in topics:
            f.write(f"# {topic}\n\n")
            for _ in range(random.randint(3, 7)):
                f.write(f"{topic} content line {random.randint(1, 100)}\n")
            f.write("\n")

if __name__ == "__main__":
    if not os.path.exists('docs'):
        os.makedirs('docs')
    generate_random_docs()
