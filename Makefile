# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yitani <yitani@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/11/27 11:04:20 by yitani            #+#    #+#              #
#    Updated: 2025/11/29 21:37:49 by yitani           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all:
	mkdir -p /home/$(USER)/data/mariadb
	mkdir -p /home/$(USER)/data/wordpress
	mkdir -p /home/$(USER)/data/portainer
	docker-compose -f srcs/docker-compose.yml up -d --build

up:
	docker-compose -f srcs/docker-compose.yml up -d

down:
	docker-compose -f srcs/docker-compose.yml down

stop:
	docker-compose -f srcs/docker-compose.yml stop

clean:
	docker-compose -f srcs/docker-compose.yml down -v
	docker system prune -af

fclean: clean
	sudo rm -rf $(HOME)/data

re: fclean all

.PHONY: all up down stop clean fclean re