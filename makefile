# Check if .fvm/flutter_sdk exists; if so, use fvm
USE_FVM := $(shell [ -d ".fvm/flutter_sdk" ] && echo true || echo false)

FLUTTER_CMD := $(if $(filter true,$(USE_FVM)),fvm flutter,flutter)
DART_CMD := $(if $(filter true,$(USE_FVM)),fvm dart,dart)

COV_DIR := coverage
LCOV_FILE := $(COV_DIR)/lcov.info
COV_HTML_DIR := $(COV_DIR)/html

# Clean up
clean:
	$(FLUTTER_CMD) clean
	$(FLUTTER_CMD) pub get

# Code generation (freezed, json_serializable, retrofit, injectable)
codegen:
	$(DART_CMD) run build_runner build --delete-conflicting-outputs

# Watch mode for continuous code generation
codegen-watch:
	$(DART_CMD) run build_runner watch --delete-conflicting-outputs

# Code formatting and analysis
codeformat:
	$(FLUTTER_CMD) analyze .

# Run tests
test:
	$(FLUTTER_CMD) test

# Code coverage
codecov:
	$(FLUTTER_CMD) test --coverage
	lcov --remove $(LCOV_FILE) \
		'lib/core/*' \
		'lib/shared/*' \
		'**/*.g.dart' \
		'**/*.freezed.dart' \
		'lib/features/**/domain/mapper/*' \
		'lib/features/**/data/*' \
		'lib/features/**/domain/entities/*' \
		-o $(LCOV_FILE)
	genhtml $(LCOV_FILE) -o $(COV_HTML_DIR)
	open $(COV_HTML_DIR)/index.html
