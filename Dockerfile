FROM ruby:3.4.4-slim

ENV RAILS_ENV=production 
ENV NODE_ENV=production
ENV SECRET_KEY_BASE=dummy_placeholder_for_assets

# Instala dependências do sistema
RUN apt-get update -qq && \
  apt-get install -y build-essential libpq-dev curl git libvips && \
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get install -y nodejs && \
  corepack enable && \
  corepack prepare pnpm@8.15.5 --activate && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /app

# Copia o código
COPY . .

# Instala o Bundler e dependências Ruby e JS


RUN gem install bundler && \
  bundle config set without 'development test' && \
  bundle install && \
  pnpm install && \
  bundle exec rails assets:precompile

# Expõe a porta padrão
EXPOSE 3000

# Comando padrão para subir o servidor
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]
