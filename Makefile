# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yitani <yitani@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/11/27 11:04:20 by yitani            #+#    #+#              #
#    Updated: 2025/11/27 11:04:21 by yitani           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all:
	mkdir -p /home/$(USER)/data/mariadb
	mkdir -p /home/$(USER)/data/wordpress
	docker-compose -f srcs/docker-compose.yml up -d --build

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker-compose -f srcs/docker-compose.yml down -v
	docker system prune -af

fclean: clean
	sudo rm -rf /home/$(USER)/data

re: fclean all

.PHONY: all down clean fclean re