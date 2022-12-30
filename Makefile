# crappy, to be improved

ifndef VERBOSE
.SILENT:
endif

MAKEFLAGS += --no-print-directory

DIST_DIR=dist
POSTS_DIR=posts
SCRIPTS_DIR=scripts

all: clean build serve

clean:
	rm -rf $(DIST_DIR)

build:
	./$(SCRIPTS_DIR)/build.sh $(POSTS_DIR) $(DIST_DIR) $(posts)

serve:
	python3 -m http.server --directory $(DIST_DIR)
