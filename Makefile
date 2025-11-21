NAME_SERVER = server
NAME_CLIENT = client
CC = cc
CFLAGS = -Wall -Wextra -Werror -I./include -I./libft

# Directories
SRC_DIR = src
LIBFT_DIR = libft
INCLUDE_DIR = include
SERVER_DIR = $(SRC_DIR)/server
CLIENT_DIR = $(SRC_DIR)/client

# Server and client source files
SERVER_SRC = $(shell find $(SERVER_DIR) -name '*.c')
SERVER_OBJ = $(SERVER_SRC:.c=.o)

CLIENT_SRC = $(shell find $(CLIENT_DIR) -name '*.c')
CLIENT_OBJ = $(CLIENT_SRC:.c=.o)

# Libft sources (automatically find all .c files)
LIBFT_SRC = $(shell find $(LIBFT_DIR) -name '*.c')
LIBFT_OBJ = $(LIBFT_SRC:.c=.o)
LIBFT = $(LIBFT_DIR)/libft.a

# Colors
GREEN = \033[0;32m
BLUE = \033[0;34m
YELLOW = \033[0;33m
RESET = \033[0m
BOLD = \033[1m

# Build messages
MSG_COMPILING_LIBFT = $(BLUE)Compiling libft...$(RESET)
MSG_COMPILING_SERVER = $(BLUE)Compiling server...$(RESET)
MSG_COMPILING_CLIENT = $(BLUE)Compiling client...$(RESET)
MSG_CREATING_ARCHIVE = $(YELLOW)Creating libft archive...$(RESET)
MSG_LINKING_SERVER = $(GREEN)Linking $(NAME_SERVER)...$(RESET)
MSG_LINKING_CLIENT = $(GREEN)Linking $(NAME_CLIENT)...$(RESET)
MSG_BUILD_COMPLETE = $(GREEN)$(BOLD)✓ Build complete: $(NAME_SERVER) and $(NAME_CLIENT)$(RESET)
MSG_CLEANING = $(YELLOW)Cleaning object files...$(RESET)
MSG_CLEAN_COMPLETE = $(GREEN)✓ Clean complete$(RESET)
MSG_REMOVING_BINARIES = $(YELLOW)Removing binaries...$(RESET)
MSG_FCLEAN_COMPLETE = $(GREEN)✓ Full clean complete$(RESET)

all: $(NAME_SERVER) $(NAME_CLIENT)

$(NAME_SERVER): $(LIBFT) $(SERVER_OBJ)
	@echo -e "$(MSG_LINKING_SERVER)"
	@$(CC) $(CFLAGS) $(SERVER_OBJ) $(LIBFT) -o $(NAME_SERVER)

$(NAME_CLIENT): $(LIBFT) $(CLIENT_OBJ)
	@echo -e "$(MSG_LINKING_CLIENT)"
	@$(CC) $(CFLAGS) $(CLIENT_OBJ) $(LIBFT) -o $(NAME_CLIENT)
	@echo -e "$(MSG_BUILD_COMPLETE)"

$(LIBFT): $(LIBFT_OBJ)
	@echo -e "$(MSG_CREATING_ARCHIVE)"
	@ar rcs $(LIBFT) $(LIBFT_OBJ) 2>/dev/null

# Compile libft object files
$(LIBFT_DIR)/%.o: $(LIBFT_DIR)/%.c
	@echo -e "$(MSG_COMPILING_LIBFT) $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# Compile server object files
$(SERVER_DIR)/%.o: $(SERVER_DIR)/%.c
	@echo -e "$(MSG_COMPILING_SERVER) $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# Compile client object files
$(CLIENT_DIR)/%.o: $(CLIENT_DIR)/%.c
	@echo -e "$(MSG_COMPILING_CLIENT) $<"
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo -e "$(MSG_CLEANING)"
	@rm -f $(LIBFT_OBJ) $(SERVER_OBJ) $(CLIENT_OBJ)
	@echo -e "$(MSG_CLEAN_COMPLETE)"

fclean: clean
	@echo -e "$(MSG_REMOVING_BINARIES)"
	@rm -f $(LIBFT) $(NAME_SERVER) $(NAME_CLIENT)
	@echo -e "$(MSG_FCLEAN_COMPLETE)"

re: fclean all

.PHONY: all clean fclean re