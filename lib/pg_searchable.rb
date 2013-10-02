require 'pg_searchable/version'
require 'pg_searchable/active_record'
require 'pg_searchable/arel'

# TODO:
# 1) add migration helper for generating tsvector update triggers
# 2) add migration generator for Hunspell dictionary
# execute <<-EOS
#   CREATE TEXT SEARCH CONFIGURATION english_custom ( COPY = pg_catalog.english );
#   CREATE TEXT SEARCH DICTIONARY english_hunspell (
#     TEMPLATE = ispell,
#     DictFile = hunspell_en_us,
#     AffFile = hunspell_en_us,
#     StopWords = english
#   );
#   ALTER TEXT SEARCH CONFIGURATION english_custom
#   ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, word, hword, hword_part
#   WITH unaccent, english_hunspell, english_stem;
#
#   DROP TEXT SEARCH CONFIGURATION english_custom;
#   DROP TEXT SEARCH DICTIONARY english_hunspell;
# EOS
# 3) add ranking functions for full text search
