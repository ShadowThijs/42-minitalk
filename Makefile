NAME_SERVER = server
NAME_CLIENT = client
CC = cc
CFLAGS = -Wall -Wextra -Werror -I./include -I./libft -I./ft_printf

# Directories
SRC_DIR = src
LIBFT_DIR = libft
FT_PRINTF_DIR = ft_printf
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

# ft_printf sources (automatically find all .c files)
FT_PRINTF_SRC = $(shell find $(FT_PRINTF_DIR) -name '*.c' -not -path "$(FT_PRINTF_DIR)/libft/*")
FT_PRINTF_OBJ = $(FT_PRINTF_SRC:.c=.o)
FT_PRINTF = $(FT_PRINTF_DIR)/libftprintf.a

# Progress tracking files
LIBFT_STARTED = .libft_started
FT_PRINTF_STARTED = .ft_printf_started
SERVER_STARTED = .server_started
CLIENT_STARTED = .client_started

# Colors
GREEN = \033[0;32m
BLUE = \033[0;34m
YELLOW = \033[0;33m
RESET = \033[0m
BOLD = \033[1m

# Build messages
MSG_COMPILING_LIBFT = $(BLUE)Compiling libft...$(RESET)
MSG_COMPILING_FT_PRINTF = $(BLUE)Compiling ft_printf...$(RESET)
MSG_COMPILING_SERVER = $(BLUE)Compiling server...$(RESET)
MSG_COMPILING_CLIENT = $(BLUE)Compiling client...$(RESET)
MSG_CREATING_LIBFT_ARCHIVE = $(YELLOW)Creating libft archive...$(RESET)
MSG_CREATING_FT_PRINTF_ARCHIVE = $(YELLOW)Creating ft_printf archive...$(RESET)
MSG_LINKING_SERVER = $(GREEN)Linking $(NAME_SERVER)...$(RESET)
MSG_LINKING_CLIENT = $(GREEN)Linking $(NAME_CLIENT)...$(RESET)
MSG_BUILD_COMPLETE = $(GREEN)$(BOLD)✓ Build complete: $(NAME_SERVER) and $(NAME_CLIENT)$(RESET)
MSG_CLEANING = $(YELLOW)Cleaning object files...$(RESET)
MSG_CLEAN_COMPLETE = $(GREEN)✓ Clean complete$(RESET)
MSG_REMOVING_BINARIES = $(YELLOW)Removing binaries...$(RESET)
MSG_FCLEAN_COMPLETE = $(GREEN)✓ Full clean complete$(RESET)

all: $(NAME_SERVER) $(NAME_CLIENT)

$(NAME_SERVER): $(LIBFT) $(FT_PRINTF) $(SERVER_OBJ)
	@echo -e "$(MSG_LINKING_SERVER)"
	@$(CC) $(CFLAGS) $(SERVER_OBJ) $(FT_PRINTF) $(LIBFT) -o $(NAME_SERVER)

$(NAME_CLIENT): $(LIBFT) $(FT_PRINTF) $(CLIENT_OBJ)
	@echo -e "$(MSG_LINKING_CLIENT)"
	@$(CC) $(CFLAGS) $(CLIENT_OBJ) $(FT_PRINTF) $(LIBFT) -o $(NAME_CLIENT)
	@echo -e "$(MSG_BUILD_COMPLETE)"

$(LIBFT): $(LIBFT_OBJ)
	@echo -e "$(MSG_CREATING_LIBFT_ARCHIVE)"
	@ar rcs $(LIBFT) $(LIBFT_OBJ) 2>/dev/null
	@rm -f $(LIBFT_STARTED)

$(FT_PRINTF): $(LIBFT) $(FT_PRINTF_OBJ)
	@echo -e "$(MSG_CREATING_FT_PRINTF_ARCHIVE)"
	@ar rcs $(FT_PRINTF) $(FT_PRINTF_OBJ) 2>/dev/null
	@rm -f $(FT_PRINTF_STARTED)

# Compile libft object files
$(LIBFT_DIR)/%.o: $(LIBFT_DIR)/%.c
	@if [ ! -f $(LIBFT_STARTED) ]; then \
		echo -e "$(MSG_COMPILING_LIBFT)"; \
		touch $(LIBFT_STARTED); \
	fi
	@$(CC) $(CFLAGS) -c $< -o $@

# Compile ft_printf object files
$(FT_PRINTF_DIR)/%.o: $(FT_PRINTF_DIR)/%.c
	@if [ ! -f $(FT_PRINTF_STARTED) ]; then \
		echo -e "$(MSG_COMPILING_FT_PRINTF)"; \
		touch $(FT_PRINTF_STARTED); \
	fi
	@$(CC) $(CFLAGS) -I$(FT_PRINTF_DIR)/libft -c $< -o $@

# Compile server object files
$(SERVER_DIR)/%.o: $(SERVER_DIR)/%.c
	@if [ ! -f $(SERVER_STARTED) ]; then \
		echo -e "$(MSG_COMPILING_SERVER)"; \
		touch $(SERVER_STARTED); \
	fi
	@$(CC) $(CFLAGS) -c $< -o $@

# Compile client object files
$(CLIENT_DIR)/%.o: $(CLIENT_DIR)/%.c
	@if [ ! -f $(CLIENT_STARTED) ]; then \
		echo -e "$(MSG_COMPILING_CLIENT)"; \
		touch $(CLIENT_STARTED); \
	fi
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo -e "$(MSG_CLEANING)"
	@rm -f $(LIBFT_OBJ) $(FT_PRINTF_OBJ) $(SERVER_OBJ) $(CLIENT_OBJ)
	@rm -f $(LIBFT_STARTED) $(FT_PRINTF_STARTED) $(SERVER_STARTED) $(CLIENT_STARTED)
	@echo -e "$(MSG_CLEAN_COMPLETE)"

fclean: clean
	@echo -e "$(MSG_REMOVING_BINARIES)"
	@rm -f $(LIBFT) $(FT_PRINTF) $(NAME_SERVER) $(NAME_CLIENT)
	@echo -e "$(MSG_FCLEAN_COMPLETE)"

re: fclean all

.PHONY: all clean fclean re