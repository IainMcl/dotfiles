def test() -> int:
    """
    test

    This is my test docs
    :return: int
    This is my really really really really long line that I am expecting will go over 80 chars and I want an error to show.
    """
    return 1


def main():
    # This is my thing
    test()


if __name__ == '__main__':
    main()
    main()
    main()
    main()
