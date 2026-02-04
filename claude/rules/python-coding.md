# Python Coding

## Documentation

- New functions should include docstrings that describe their purpose.  This
should not include things like `:param` or `:return:` sections, just a brief
description of what the function does.

- Use type hints for function parameters and return types to improve code
readability and maintainability.

## Code Style

- Use modern practices. For example use f-strings for string formatting instead of
`%` or `str.format()`.
- When typing use `list`, `dict`, `set`, and `tuple` instead of `List`, `Dict`,
`Set`, and `Tuple` from the `typing` module, unless you need to specify type
parameters. For optional parameters use `| None` instead of `Optional`.

## Logging

When logging messages add the additional context in the `extra` parameter of the
logging methods. For example:
```python
logger.info("Processing item", extra={"item_id": item.id})
```

When logging exceptions use `logger.exception` instead of `logger.error` to
automatically include the stack trace. For example:
```python
try:
    process_item(item)
except Exception:
    logger.exception("Failed to process item", extra={"item_id": item.id})
```

**DO NOT** include exception information in the log message itself. For example,
avoid doing this:
```python
try:
    process_item(item)
except Exception as e:
    logger.error(f"Failed to process item: {e}", extra={"item_id": item.id})
```

