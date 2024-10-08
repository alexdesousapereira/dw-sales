PGDMP      -                |            stage    15.3    16.2     %           0    0    ENCODING    ENCODING     !   SET client_encoding = 'WIN1252';
                      false            &           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            '           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            (           1262    1293466    stage    DATABASE     |   CREATE DATABASE stage WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE stage;
                postgres    false                        2615    1293467    vendas    SCHEMA        CREATE SCHEMA vendas;
    DROP SCHEMA vendas;
                postgres    false            �            1259    1293468    alembic_version    TABLE     X   CREATE TABLE vendas.alembic_version (
    version_num character varying(32) NOT NULL
);
 #   DROP TABLE vendas.alembic_version;
       vendas         heap    postgres    false    6            �            1259    1293474    logs    TABLE     �   CREATE TABLE vendas.logs (
    id integer NOT NULL,
    log_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    log_level character varying(10),
    message character varying
);
    DROP TABLE vendas.logs;
       vendas         heap    postgres    false    6            �            1259    1293473    logs_id_seq    SEQUENCE     �   CREATE SEQUENCE vendas.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE vendas.logs_id_seq;
       vendas          postgres    false    217    6            )           0    0    logs_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE vendas.logs_id_seq OWNED BY vendas.logs.id;
          vendas          postgres    false    216            �            1259    1293484    monitoring_stage_data    TABLE     Q  CREATE TABLE vendas.monitoring_stage_data (
    id integer NOT NULL,
    data_inicio timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    arquivo_original_registros integer,
    registros_apos_limpeza integer,
    registros_ignorados integer,
    data_fim timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 )   DROP TABLE vendas.monitoring_stage_data;
       vendas         heap    postgres    false    6            �            1259    1293483    monitoring_stage_data_id_seq    SEQUENCE     �   CREATE SEQUENCE vendas.monitoring_stage_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE vendas.monitoring_stage_data_id_seq;
       vendas          postgres    false    6    219            *           0    0    monitoring_stage_data_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE vendas.monitoring_stage_data_id_seq OWNED BY vendas.monitoring_stage_data.id;
          vendas          postgres    false    218            �            1259    1293492    stage_sales_data    TABLE     �  CREATE TABLE vendas.stage_sales_data (
    data_venda timestamp without time zone NOT NULL,
    numero_nota integer NOT NULL,
    codigo_produto character(4),
    descricao_produto character varying(100),
    codigo_cliente character(4),
    descricao_cliente character varying(100),
    valor_unitario_produto numeric,
    quantidade_vendida_produto integer,
    valor_total numeric,
    custo_da_venda numeric,
    valor_tabela_de_preco_do_produto numeric
);
 $   DROP TABLE vendas.stage_sales_data;
       vendas         heap    postgres    false    6            �            1259    1293503    view_cliente    VIEW     �   CREATE VIEW vendas.view_cliente AS
 SELECT DISTINCT ssd.codigo_cliente,
    ssd.descricao_cliente
   FROM vendas.stage_sales_data ssd;
    DROP VIEW vendas.view_cliente;
       vendas          postgres    false    220    220    6            �            1259    1293499    view_produto    VIEW     �   CREATE VIEW vendas.view_produto AS
 SELECT DISTINCT ssd.codigo_produto,
    ssd.descricao_produto
   FROM vendas.stage_sales_data ssd;
    DROP VIEW vendas.view_produto;
       vendas          postgres    false    220    220    6            �            1259    1293507    view_sales_summary    VIEW     �  CREATE VIEW vendas.view_sales_summary AS
 SELECT stage_sales_data.data_venda,
    stage_sales_data.numero_nota,
    stage_sales_data.codigo_produto,
    stage_sales_data.codigo_cliente,
    stage_sales_data.valor_unitario_produto,
    stage_sales_data.quantidade_vendida_produto,
    stage_sales_data.valor_total,
    stage_sales_data.custo_da_venda,
    stage_sales_data.valor_tabela_de_preco_do_produto
   FROM vendas.stage_sales_data;
 %   DROP VIEW vendas.view_sales_summary;
       vendas          postgres    false    220    220    220    220    220    220    220    220    220    6                       2604    1293477    logs id    DEFAULT     b   ALTER TABLE ONLY vendas.logs ALTER COLUMN id SET DEFAULT nextval('vendas.logs_id_seq'::regclass);
 6   ALTER TABLE vendas.logs ALTER COLUMN id DROP DEFAULT;
       vendas          postgres    false    216    217    217            �           2604    1293487    monitoring_stage_data id    DEFAULT     �   ALTER TABLE ONLY vendas.monitoring_stage_data ALTER COLUMN id SET DEFAULT nextval('vendas.monitoring_stage_data_id_seq'::regclass);
 G   ALTER TABLE vendas.monitoring_stage_data ALTER COLUMN id DROP DEFAULT;
       vendas          postgres    false    218    219    219                      0    1293468    alembic_version 
   TABLE DATA           6   COPY vendas.alembic_version (version_num) FROM stdin;
    vendas          postgres    false    215   �"                 0    1293474    logs 
   TABLE DATA           E   COPY vendas.logs (id, log_timestamp, log_level, message) FROM stdin;
    vendas          postgres    false    217   #       !          0    1293484    monitoring_stage_data 
   TABLE DATA           �   COPY vendas.monitoring_stage_data (id, data_inicio, arquivo_original_registros, registros_apos_limpeza, registros_ignorados, data_fim) FROM stdin;
    vendas          postgres    false    219   �$       "          0    1293492    stage_sales_data 
   TABLE DATA           �   COPY vendas.stage_sales_data (data_venda, numero_nota, codigo_produto, descricao_produto, codigo_cliente, descricao_cliente, valor_unitario_produto, quantidade_vendida_produto, valor_total, custo_da_venda, valor_tabela_de_preco_do_produto) FROM stdin;
    vendas          postgres    false    220   A%       +           0    0    logs_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('vendas.logs_id_seq', 8, true);
          vendas          postgres    false    216            ,           0    0    monitoring_stage_data_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('vendas.monitoring_stage_data_id_seq', 1, true);
          vendas          postgres    false    218            �           2606    1293472 #   alembic_version alembic_version_pkc 
   CONSTRAINT     j   ALTER TABLE ONLY vendas.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
 M   ALTER TABLE ONLY vendas.alembic_version DROP CONSTRAINT alembic_version_pkc;
       vendas            postgres    false    215            �           2606    1293482    logs logs_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY vendas.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY vendas.logs DROP CONSTRAINT logs_pkey;
       vendas            postgres    false    217            �           2606    1293491 0   monitoring_stage_data monitoring_stage_data_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY vendas.monitoring_stage_data
    ADD CONSTRAINT monitoring_stage_data_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY vendas.monitoring_stage_data DROP CONSTRAINT monitoring_stage_data_pkey;
       vendas            postgres    false    219            �           2606    1293498 &   stage_sales_data stage_sales_data_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY vendas.stage_sales_data
    ADD CONSTRAINT stage_sales_data_pkey PRIMARY KEY (data_venda, numero_nota);
 P   ALTER TABLE ONLY vendas.stage_sales_data DROP CONSTRAINT stage_sales_data_pkey;
       vendas            postgres    false    220    220                  x�K3�L�0J33KNI����� /M         �  x�uR�n�0<K_��%)�0����Q+��@��=T��H�V�D$e8�[�/z*i��ʼ������D74�	,�X�Q��W�w+���P�$<qQKh�H����=Ԩ�$~0� 㘍��n��E�5�@?q�y�z�p���A��6<�8aW���w��g�G�(��@��� ��+�> �"d�9�o������y�h�}]�ˢ��uЊ��Ι��a�#nMr�8|+�/��b	��c�A�n��֢��A�#!p�7C�O�͓8��|�^��\YY\��U��k�/	����-���0|�R�y�Z_��1�\�'vQ����!���ى��\]������Rz��J��p�~TM(��S���<�����5��X��]�]V�i�ci�v=6�6��3���M�����[���U�4���O'$Q��0>Ԫ��=փ����������      !   =   x�mʱ�0���F�@��x�9��i�:��\x��K��-ň�6��O�@UO�	w�7      "      x�����-ɑ���)��?����$A-��z0�B�4*�M
l6���ͣ�h�Yi5n�Xa�y���[*�y�DFx��������C�}H����}ůa|��_����o���Ͽ��Ͽ��?��������_�!�d���������?���WL_1��]�W�|��5�w�_����	ϟ_����?��=������������/��_������_9��ҿ��Qɞ���{Tƣ���?��?���뱿���������{̯>�Zi�;ǯZ��%����Mc�}̿=��������O��񪅿���*�|����O����W��w�߇�i�y]m��_�����w?��/���{ښ[V[�1�fJx���R�]�oOoxz�������L�|ϯX�r���+��m?,���������n���?����RF���������G��n�kڗ���ʰ%�����oO���������o?��?7��~�ӿ}��=�+�1�c���ڦ�_��M�a����/>�����_�n����nO#}w<���%y��ڇ�Tl)~��O��_�?��U���w�[׆-�z�nm�G��6��q���m��ڶ�NJ��3����}o�9��7�m����݊=zr]�o�h��n��Y���?����~���W�_����������5�w�ל_��#67[k�N�K��/��Sٞ�CԾ��¢������?��X�־mCU{��;٪6�v`�o�0uY�[��bh8�����}o;��6p����U;v������=���C4m3ľ���������|�f�)��mO�1}��,�؞8�#h�n�Bc��ًe;�{��!O��iEV���?���J�����g�=�_����h�f��gilq����bq��9U�-��I��B]��ɶ�z���/��������]3Nu�*U���W��@%���c����)R�#eGlv��m+E{������!*�o�q��vF���c�/���Z��U���N��"}��;����"Q�����%��oP�"OB8�-]�4�n�Gj��^N�]��5-��Q�A*�"���m��~�h��kk��ox��f�%���p����l������֑�����?���hX"��q�1�v7#�ٟ�#���?���?�駫�#dQ��F��O�pq�au�Os�g���F�Bz�,�(�	��H�_�窾�������^4{��w�SS��r/Y@�/��퇜|v�����}�Xڷ��!��r�}���&O�v��~��Zk���N�e~���c��E�cZLG�>A�þ���m7;;�^�=Q=N�����efa�0#Ц��[ ���'9�����v��[B$��F+�l!*?��#�)�����ײӕ�]�vQ5���ݟ�݆�������Ο�pf�u��q�B�@`��-WFdY��[D��Ʈ�ŕTu`Wv�j{.F��y?�I�vyWN��p���^���0�;�۱��}s�t���������-V=�G�J�m�K>v���>+.���b���E�vE)>����; v�,����؃A�}�"l�G���p~�"�����-G�踧���e2,Q��f�Z�aueM�����j�[��s���W������?��g�P���Eҍ�5��F�ޟ}خ�o!��XBI0΃����}0��-�!����*��{j����Ф��m�=����0j��sk/m�\��]P�Yָ=������>Nh�d)�%��ɞ �r�"YC�T�k�8�ѐ⥊�R<K��~�E�vj�<�e�[�6g�����ņ�Z������UQ�%6���Z��5!�v�xeb��E�C�^n��́�Bqؒ�,�%�5WL�j#炳=�>��Cv�ϴ�֩�������u�J#-��ѷ�C���&����Y-���ej�����=�k�SϢ��VRv\jv\�ݫ)Y�����}���g�>���q�8&�R�\�z�Hpn��9�{�����2b�Ӱ��Z���h��p�-�G�>��c����5�-�|d rm��w�˳��:���,�m;"�9�	���v!O[U��K��N�$Y{����J(~c��>�]���3���N�½0n�GPK���-vK�&�B����.����[��B���NI���J��xi���g��K�Vc"C���,2�K+KY��I�.F� }�����&�W$��!o;Bփ{O8��~��f�!��cR4qh{�`�t�����|��`m����Xƺ8b�R��q��������\L�8d���m��au�m* �3�1�@��x�V�j�ST-�Xq�B��������w���^�����X+��~�����3*���b�be��֯$tS��&���KR��]�l�&|�Q��O����=���To���v=�T\`sOj���JM2���i���6<2Y�����n�P#\fR���Y��oޑ���PLE-���1��1�udD�}[V�Zl���]��a	��ϼO,0G˺� �f�ɾ�(����׫��@I0���UN�]���Q��ʶT���� G��R[�,w��F���ۇ�<Ӿ�-l�(I-�Ka|[��)e�h���+�B���&�TIK�O���1��ux��c���3���D�%I򳿤�����ả�ٴ<n�}�&qx��יhD��SJ�_k!h�m+�f��JGh�w,�$�kE���{dOR��x��U�kx�J&tR�hn!���? �(��նvST�M[=YN��~�����ﰪ��޾�<�m -��j�:�o�}-�i��m�2,ձ,p������]5C��B7Ў6p���ˮ�-�rd直�l�7<�.�v�':es/���������J�a� ��YW(����GwL�`dd�,�B��*�`�����ucV����d��h�$w����\/[a&@a	�K�V8[8�M�w�|=if?7�I)���Z��33҂�\��G�w�Xf�ֵ��	�@k$d��M|c8d�j���n�N��}���~�	�����%0�KV�5~��<����p{��������m��b��3���Ǎ}��p ����E@�x_��)i#��I�G��	{�xsJ0w�a�}�\
��j����~��?ݪ���۪�7nl/ EXA<#��{����/2�e��#|�hNL��UH��wp�a|��@w< ����8v'<zk�E�s|�3���~?�0���ך��x�o��O(� �X�v���ט��{KGX�f�^��do��D���)�:�cM�'	��*,�Es%�9�h*�x�z>�q
[���-S�\��S�3��K�o �,`�+�e�Lm4�ޓĸ(9��[$d�9�p�W^U����8&^LheU{�eN�������eF����&�M�+�g���C07��,�Yb��(U�X��*R:�Z��[�M �c��v�nT��w=gm(4T���]_�����h����o:HPd������=�eXY��eK��r1�3�8[��fB$(# ���.m{�Z�W6�4q�~p[�l0>�:���U5�u��wm�)�����o��e� b�P�7dݖ��u܎�StP[ĩ�3G�����o����>�}���UV:Knq�i'2	���u[��βh��G�=�.�
?���i�<>d�A��8�'�*�rr���<�`ݘ�+��cd��:@���=������9��y^�_����0xz���4]��T���o�F��M��㯻��2b5�n[��Z��w�fp����@p��`>W����VM��r*Ԃ;p�:-��b`S���@w\4�����	�xm�T ��:�cO{�n.�����ڨ����VI@v$�=ڑrne.*�]�)��<'�A����I���&"ή��-���J�[L��nw%7�+|��7�ء��`�9�y�'�Պ�F��(����%-0�jw�a��ݶ�Sg�%��2�x��	l\�T&Ѭ<Cܳ�UK��\}�Z4�{%�-V�ߴ��u)z�^���.��'/.��{Tm��6��E��J�sqS��&��5M��JG�r�ޖf
{ �    ���B�2�G�u��R�ף(�_?������p����S�呮(S)���>w�T�����x���j���
�"���m-BQ�Ng���q��"*`F�+a��2�ج�o]�|Iƪg�_ݱ��Z"�Rr^��&�NP����� a�6+YP����ʴ�`]O����*�=*)��쎳L�uo�/ ���z��5N[�5$�3nK�,�0�F�F�.J��ZS�
�i��lFTس��Wp��d[�)�%�z�����@q|�v2~���d�8��0��{��e��pP���V*gP95)���Q)��`�	�h�@ƥ���dc�m1�V��c��vS�ma���Ē<�٦>�0���n4��`�R$^�q�\��x�nX~IXi�O˔�=���'n���4�i��l�.7�~�����h:�+��АaY��� �ɺw��3�FmqR8�E:o��i(����b`Ž?,X�
��'�9�m��y D�̟��D�ވmɍ�7�ı�c�����o�����~�JN�h���o�d��tkDk���e���ُγ|�TX�"ZZ��k�*r�\��ON�˯"+��JF���E��Y3�~4��-�^!
{�}&�L�S|�$��߬�9q^�;��,rMk�$軟��.��ͨd	5�]Lm��э���D�0���F.���l2'W�p7���`S�����{d���})=k���a���אO��=�����D3&gl;����e�.Y۾��;,� 3X1�EpΎ��u�5x�9���>���`8�����E*�#� ��9i\Kr�����Z?ѣ���JK�������Ѷ6g�<<C�XY�-�2��5/rDV/!7�8r��k: k[f;�A�K��j��ɒ�:�kR�U�G��&Z��`^��v4pA�4@v�������8Z�xO�-~[p��y�c�{����.s�?[m	����pb�'�r;@�,s��j�C䒈Ƥa��Tr�����}t�D�b�ş�r<����=�A�s���b�-�����C��3�
����P��C��t)�</���-8"�Coǣt��#�x,Z���U��(�@9,� �i5�|���<n�3��Ejbڇ��&R��ۓ��)��<o�����TUUy��\>ː��^$>]�J(���w����b{}5��l�~'kFy�;M18NiX���Nj'���+F��NiEΔ��YL琪�r�[�ÙG��A�$�T|�#K2�x���� ��ZY�������?.4��lw"��RB[�/N���{O�s%���W8T�" L�@�W�'�W���创E)�*�gk��V�t$ ���c<E�D��`�0��"h��vj�y���ᮙ�Wi�D���찕�:���{L/��	��p�.�������$���y���,�)��Y�b���P>�r�N 	�vޒ@E�� S�⏩�P��
�R��E7%o�n/�󆷋�>���c
	j4m�<�N��r�$WÎ&ܺ���Wc��G�vF����}'�+M�m����3Ϻ�aV�������h�B&��[Œ����~
QgK_'���'�ז�_�����n�WV8�Hн��Usj9�h��^Ғ1��찡О�!��'#�ne���a{�6S���B.�)0)�Ș���?e�R���.�D��،�P���,7cگ���f?��;��>�S�񀒾p�W>]䭂��A1�v$���|����D�]�gG����;�^2n<��=�1;˞tw\�({d��'�?ڇ�e�*��oΟk�$���I���dA�R��
��|��|x�\Y�n1p�j� �,}����C�ү�i���i���Ѿ��V�!���J�MD�R���P�T%���Gļ�LG�+;J_�
X��;|?���(��4;}�ָ$5�g7��Y��Hd�.$'�"��;ЮI�T�?u�d��nJ�O\*7_��$E:��0��\.)�i�a)"#�����F|���ؠ��R��������ٍƭ:A?T%�}U�c���{�1�?A@�B���w�l��S���i� ,��3�V�;b����:}���(���TV3���ߗv�	vb���o���wLyMQ�z�2:����
�?Z󠏬ɿ�����~sX����T�Y��»�s���s%I|�Rd[/ bX
�z�����؄�Ч�+�$T��w�݄/i8@�qʚVۋ�}����ۻ�!����_��_Jbv�W�r� � �H͟<8�Y%j����"a$v��j2�a���*��Ð?2,�9.����}4�����E^��d�@{dT����&A���+q>�$�"32d���z��߬%�x_`�*p"H��]�$�w�"u	�rʇ�V*����G�^y�0i�l?!���H$��Q�C�h-�z[�|��yZL���j׬b�HH�~��'���D��F��B�b�G1�CBX���զ�Lѵ�&�C��ͽ1i�%#�w�w��%)�I �h{1�u�ߊy�uy;	Ϲ�ch��ؕS�ӆ@�p�|З�/>��}eE"����K )q�
XpG�H�s�g� Q=34g3�`%S�節T���t��ŋ'��I�2MX�c����?��e��R*1;�Z��~�<!%y�B�-�T"��u%�vw��т��a%�y5�1�[�$���}�=rv6-ڢ<�Ύ�^w41�\^�����J%�����ZS�l���o'L�BZ(��c���2!�/��g�6 )[�ne���=�
z{J ��@�����G*l"!��+��@���-���G*I9� ��(��a5�uԢ�sPa=���!����6�j�Du*�E�ic���}�ȅ7���.A�٠�D&s��a��w`�84��*{OV/��)�P��>��YD>�ȁ�)5�tt!�c=|�ە#����/Ƹ��x����{��1p�*��;�4(�1�=e�5���s:�s�"dg9��F��Vy�9Z�ٻ�YZmH���ԡ{�Y|��y��$��t�d�d+cq��'kK�2&Jd@Ubfc��m�7���&:ڠZٍK�D�J{q�v�Ir!B�� e!QӾA�:Ȅ���τC��!������,'���HN�<��'j�G�cϗ���w��뾌��.���N�]�žu�ɉ��@�滬�ȸ��(p��h����Z�Tr
��$YS�y��c\�
\��G�\�F�������D��$�51�g���-"�M/1�I�A8��O	c��7+Y��ѐ}���O�R@.CCP��.�B4�ּX%�lh�����H,\p)O���s�Z�����lSCa�}�a�������v�&I��T��B܉��
#�����A\A�
�@���"{*�������R�_6�,s)K�F.�����l8�7Ɏ>i��z�����(�K.�>���	�6��Kw ���ꩥ��wii�*�H��J��b-J�����ǁ���zXe$jN��㞐��nTU�(�k~fV�|�PX���|���'������K�k^#
Iho��� M|ԛR�)�s2��.{�h�9^��:����ϰFm�J^㼪V!���RܐPY�Z��_-�$*"B������H WiPt6R#Kf�}��r;T\!}A�̀��������_O�}G?e�ű#5����0��9��<p���n�FE	��{Ӟ���V�1G�cڌ̇b7��J}N����ɫ&��CX�eIN{��H͹C����=��gV0#\��B��>��efj~T��L��}S�� ��G�"S�
��iT�B9d'r,O=:sW�`#��Z��A}G$r\�����:��s��>a�	qGu��Z�2�O4��%��2����:)�':=�^�T�`쨳��.�mBN�ΠxQZ����ǧǞW��d~��`�ͥ�H`��2p
���G�t��`���&֏	�9yS���x_`-��U���6%Y����.�jPTg����h�}���>����	�u2�]fW	X�˧$�I@#��w$��K+z/>ţ�|kf8��]ڷ���SG��s>��͸����lp�S    	s]Op>�7=�P��oɪ�@"zu �PY�M�'�����7�$cs�VZ��(��9� �8R2��rS&�\:�� pZQ�"�0A�8�x�#�d8�zj��\����@H��O����<�DJv�cv}A���$T�H���q�ͺЫ���!�d������^������a�x���ҏVh����W9��vN<r�V]:�`��Ո�)����������p;�a�3���s�Ǿ��[�{���.?;3�ƛ��J�rUY+qV=�D�q�A�4�"-�,W�=o��kyS��]Q�~�3��pJh�uq"����ιb頺K���cj�i����$^�(�@l�D�+�������⍭�Kf�9�h�S��\O��K��c ДMi���+Q�Ey���ଝ)��<���#����B ��!�0Ǡ%���Ȗ��1��[�.(��UN�eGA�ޓJ4�[y�4��@=*��-]+���_j�|�r(+�e���Wݿr$�O��RE�� 
p���	����q]I=�G!=�5��T������z�S�櫲sV�c]����x8��	��G�wd�S������-�F��N����xG�:��:El��H�Q��J��i#�G�O"/�ݐ��ՋU��4�q�����B���5��L����xʉdT��/M&������\]�3�t(jFWM<��:���q����v_���K�ԡH-��t���a{[���B�&P�2>t����^7�M���g*{�&9Q��p�'�@WNZ|.+�N*gh�<�b��4Syg�l�a�Œ���A�H#3Q���m���I�yjy�ٻv�~"4m����n�h��ٜ%P�u�@ր}	y�����죘�8�������I��)+j{�,{�uw�isD�A	�
t���O9Ȯ|ӷ��<� ���Dh���[�����%~D�#�	��������M�Y.S�^�ϥ�[CN�vэ��q���tc@_zŢǭ�'>��]iS)n�;4K�Ua�lƙ#w-�f�s��j�J4��q	&}T�$���0T��%5��!#Φ�毣�5��F�d^MJ��N�N�^�[U��H"!~�7�@��xX����k����Xܘ����k�c� �l���CXU�>�w���F�I��<��`���!�;⼚��q�O6���c�H=5!c���,�������f����w����6e~���1'�d�׬���wI����:aɇ�!���`��������d#.5[�]��g �@YLq«L�b��L��l'9�_�l�5j��e�,dnE��|��;�6r�0��,H,30�a�K,�����uD�3;P;�!s�=��Q�<�H��B����-鿄��Դ[߳��uy2�`+~�1��&WA��s����j\�xPR+a����W�f;��vjю=jLɡv�V�uU��Q����y�V����o�����k�5~G�ү�l�U v���lC����{ֱ���g�vؽO���V���!<8iHoe�
/��V�Cr����5>TH.���(l�`d>5?�p` >9�#3_^��
t�ț�R)��h^iٔ�K�0�ʯ3�;a���4�l�W����ن�Y}�'���Mz��ئ�l�j�nO�a.s �	��I�1�i<�����#����@(�Z���7R(���Y��,{�H�J*{Q^��\	6��[�q��j�#-��~��.�,��}|��?z��X����=8l9�E�LO@��
�i',#Ұ[�5��t���nY�Z1��V[���d�+�IX#w�#_��B���t�4��\�y0]X��4�m�?��2y�ȃ��p1�S��lMIDp�%��`d��9F���g�>�˴S��~'�倶���`�v#@�y{]nH!�yޖc���Do�4�:��$�:.�K;�>��j0������/�gn� E�V_��;ZI�����4lX@�Rf�J�7�������%Q��B��������?������s(%����R�k9����uΪ��|v�N%^�3L�@Q�GM�%M�"��3oa��p��c~��ϪQ�)�eFfg:�}�W�c���C��_=S	0��V�"򱎳u�J��ı��]��Ƥ|��!�e�� �3�C�2���8}�}�Z>e�~%�����Y��vK��qTjȕ��`�栅˧�1�#������*�-F�9�_,D��.���cP��
��W+�bQ�m�B�7��W�Rُ���1&Hf�qi)�ʻ����+�FK��PR�.^)O62���3�cB�o��ga²��9�N�0ҮE3D" I�I��C��X����Q+F2-Ujk/�ʏ栝�s�<=�Y`Y�E	���6�:�n9�G�A��#�U��[�R;Y%)��-�#3�S�C�[�c����e��������NB�K1:E��W�d"
r����^{#�ԓ��ZO4&B�4/1��t�M�z;p�vp�,��`�[�-w4�ROB�>g�B���b�>�o��A4+��2�Q�������oU�[�����C��z�� �*t��p�\�ږ�3%"�X��R�'��n���"s�X.X���'�$�ʝ��I��U2��*��&.8�ў����*z��"G�
P�"-N��(�Q%H�Xjn� H�}�����l`s�NH1�&��+K����0�&6�ϩ���1L���F+�-B&���*����R@�$dW�
�(�����>�1�p����i��D{�h��kn��H���'�3NAxف���]�H�O�_�nT�v����T�n�HO_��ȸ3K|.[�#���z�Q�p����X�� |!��M'�z����벓tW���#eYh!	Y%���.�BΘ�t�}#�hU.�B���0����01���@`vܘĴ߾{�Y��(��S���]4�e�aǰ���)��.��<�(`*j����v%�t>�c���CW��o�Wu�@��&+������|��5ں��t�OV��ِ�5̂&˞��;Ƿ6�k���<�5�q� ��\&Pt�rO	�#�y�tTj���bQh�e�$�qQr:�w�p	^9��Y*��$��_N���N�� ��α,����@�����j{Yx��e��}ʴs�Tௌ3�<J&ޓ��f�nQeq���3o�2@ߔ������YWƉ��$$��y��E�̷����� ��SMV���SҦ�\q�X�kRN��:�w���Ju�K�'���S�&	%���ß�����L^VVu@~�9����~�WH �����N��L߫��q�P x�-��ޭ]r�r%:k�N�x�0O�DE�Ĳq�xt4��*�e.���2�))�3e���$~�O�ES�)Q�2��7�8G)�HP��Aa���Y�#�<w'Z�b2�T�Ld�|��=�:�=���"�U�kcOWΝml 9hh�Q�{rE�� &�Vt˕0y)�c�j ���ѕ0�G��pl��C�JG�UD����6�jxc��hN�o��_%�t����t!M�d�v	�%��%j8���wj�u]P2�������GZ��Jh�*�x��MϘ���ӗ��6/�e�<�_J�w:����d/�mP�M�� ?���������d1`/��a�.'@K�2�c���Ʊ��g��'$��ǿ� �s6�L4�ڴ��[�X��������O�� v8�k��T�� ��e�Lzd���^M��m�fJ�l��G���V���: }�*L�`f�����<����e���6��VT2F�� ��Ƨ���ςq��3��36&���4^��8�#�['�.���]OGL}�B�s�IE�4 E�e (���I%�ax((R}�l�<��Pr����Q�� �e{o� %^�IV�A��7��W�X�;���t��œ��C �pB*Z*g�?�E�=��:$�W�)�2.�Ħ��V=�H��fef�%�����Y�����sm{�T��1|���ͬ3M{�X�!Q~�Œ(��n���    ig1��31�=����נ!k1��x����B�5��vLk�˃�?�;�ʛ�9x؜@3����l�n�@���]PAG�;�E	(m��O����#~�
#�y��R�
v�߽����F�u��B5Z)s�`H�R[�y�7�DM��#�#��P@u��s:炈�F�0�N`J�6�ߖ�?4q�U,$��bo#�eQ� �(�h��A���L��c'}�~r7�98��D/�Q-Fl��\�ft]��w����*����o ih8?'�X1ۙ��׬�,a�9����t�^	6GP�Az(XU�o]��$� ���%5y\�y�I�:�R�A��e���Ȕ\T2�r�Y��6 ���8j��6�!����1��qL�rЙ4�s�i�R��X��q�\e̾"�/��=��5�G<u�.�\� ��|)iI��콐Z.���*���˽�:��I�ұ`Fcr�[2�S�����˻�K�FE���@,�J���ٞǔ{��\�D��]Ƣ�����|���!Q���JAl��Xt�O��k�1�t3���2ߵ�KF�NJ}"1;��m�i��8�դ�(k󨔬���].�nۉ�)�/�N����\�}�D�HUB3@��'�O��>*#ؗ�4�j�Eh�Nis4�����;����.f�3Ȗ�G� '������w���ܖ�=H�Y�/��N�ENh�x
Tz�	E��m�|���-�x!�s���=� ߇>7ya� K:�����U�Y���;����odsuv'<k7���.��}�ja�@%ʒe���D�Y�%k�މW�t�Ӈ<t9�r�8��|P�� Pr��r�j��	�
�w�ֻǥ���=CA�D�Ǣ��K\z�D�v��Mw�z�l�e�4�{��z!T�͏���M��̹��� �=0�������$�}�s��3d�}�p^F&��w$���rY��mү�JGl#s�+�!��R���Q+��Wo{s�-�	�
����Rw$��-V��g��g���*
F�f�`����u�|��5���X���Vx��3��
`j�'�A �#8�Tu��On ��N�G��{��޿�v��K��R�mۢJꘅ�
D	���F�Mx\��@��@��?H��o[m�mgʼ����4��HK�}��8�s
QL�W�Z0�˭{�M���7�2BA66/ ��0APE�����0��¹YA�k�h�ި@2�&7�q`mˎ.��a��[�b�^0p
z���V�.a'���0����r=r�p-
�ڔ� ��q*,ܘ��u��⻹S�J�����>v��F=�"��h�˾z�"p��W�д���H����B���f:�$�l,�*��Nе~dC)��b{T�!��ڟ9��,�]0��A��UbA{8<������h�O:S��LTq�䜈�Ʊ�X�9�\���J]AH�Ĥ������E��X���5N�����YԊ��V�T}�PI8pO��[��L���`���2Yà1ҕ��]��KdAb����c,�$�}�\�I��΅=��q5{���q����i-�T5 ��;-�u�H^�CR�2��a��#�Ī���z{�.A{~2`�D��8�<� �Ql�ĳ�J^�ZC��K^;����%F�K��Y#�L�)q�PQ�~p�{�G��偉����8���h�%��DB{�L=�N(s��a�,�<���|Y �5�@O*<��F�#�;�-9S1&�y�p65��X���g�ˊ���'8�?)<Y�<����A�w� δ�n�l�NU$Ɲsܗ��;x)�wHQ=�*�@#]���n�l�]��9�P��eם?��ڡ}�����Ж�X�03��t^IV8� Whj �%��b;���N�R*������:�^��RY49��0������H��Vڥ������Y$��|�1U��2_���P�܅=%AQX�_C���A�F��^�?�m��}�������V���(/��`d飂.6Ӯ5��yM�I���?��hg*�\��>z�KO�?����Z��S[�&ob��^挵�u��N��ڲ��y��'���@;E�N�����%oHz���ļn��� @�v��[z7�v=���Pag�}-q
2
���\nn"@"3�-N�>L���� ���M��_�=��-Z��h��X���n{�n��V���Z�V���V;�i��)�2�8�VGH������x�ީ��¿
���>]��ߪ�AV�#V����Y�����{�僑�!8�(��Im�����!�S/�Մ�V'Xr�Kdʪf/��zԙ2�����@��d�yy�E*y��j����V�+����r�UZ�6�:g̀���ݗ}n��-&�hT�tY[#:���ޑt?��LR�F�b�"ei�B��a.;���V�U���}���d�@�(*1Y�n��x��S�f ��l��퇵�.[��w�T�8���Ǥ�c>�Z=��������J�8a:!���Ei��=�S��p#fj(=cK%n�$�ȶ&�Z}�_�xI�uC�0*�S6D�T�B��&�p��vF��K���D�y	��A�Ԟ(:-�v��h�)��z��U' ~'�����'�xGN�Ϭ��5-���|l�9��������9Я��=ܼ���xy 5�%�h
;y�����'b�MX�B袬�(�6��~h�V��M��4L���������'�����N�;���܉sL�VŮ?�Vq?�x��P��G�,a�H�Q/��X�250��>S��\��j|�	R�WI.dH<����϶b�~����l�Cԃ�3�E���Х�KV�DG��F9J�2sP>s�S�F]VP��ݧ�S�m����zkLEK�q�W���� �����r��C%1�Xj�R~���>غ�}y���\���N��m6�N�ߴ/������^���I����X����~\k����-ըE�Ȓ�_"k+Y�I	ٷ�� �O5�Rӗ�W�˾s���	���ê<{<��w�R��v?zL},�0�(�{AU�T^�=�D�xKq���ч
%�ԝ��*��"��	Y�xs��q��'T������E�! ������r,��;�����P8�D�QZvs(��?_���X�^8������Y�Մ���)�@-�Q���7�8�JG�'�k�ٍ�t������s}�Ӽ{���������7�A�Nm��4Sj�.a����?�=^2�^����]�&
���©�~ ��)�t�Hˠ��j�;�x�x���*4$��h�WE<�A	����ek�z��x贞U�=�f7W,P���~���F��[g���[����T���-l{��8{`��p0�"B/)��)K��]�YӠ�Q��Sc[6�ȱþ)I�O=����{Ô4�vGL�>�o���0�@�p��vhguC)�Fg��y:��C ����s�|�Tv� ����M�Iu�"�aj�KB�����!MN�B�W&ɴ��O��o�3�5�SʫR�4A� E�Sٿ��U���T��ݧI�Byay����c����3{)���hz�_��Vڠ��2��x��T��C)D7���K�B�T*��ErM��qd~n??ְ���ʵ܉#]s����Zt�\��X���ǖ���P^�ϢW�&�̂��GQ	R�����l^��|��"M܅�yF��i�v~�'��RV�7B�"k`�󠾨jB�Rm��'�9���i��D�p�镀t�v�9���'_b������
AM;.�X㰲����+_�QǦ�_��21f��:Y�r�FCf�Ǿ�c�Z3��p{=��nGcu�N�ky���W����#xP���>�(�J
[wȩ�����;�A\e�����Ʈ߱�}Y�kی�]���2�aLMjz�&����I�kor`:̻1;;@�oD����l�K:v�G`�.i觔5O��f�ez�1|��fPc���D���!�b�˼)[��s�t4Sv�ZN�x�`���Ă~d��m��Uz�a)U��
��J��W4���H���q=!�ڍ���k�$�G��_�h85��U�ͥ�Y��)hDS�Z�    '���O�/|D�[x�l'���t��os:#���e�����]<�{I�|�*ZR�Ī�D��SO�٣�8M �ٗ4i�+�t��R�ӓʁ�5��@e u ��$w��H��ϡ��0T#Z�Ie��3ՄRJhO���u;V�����H�ڷ\q/�N����)��"��Nrr�xri%6���)�횖 
��I���'���G6�)$�$-��L��Z��Q��3 !:���yR�Zm��/pؾޮ3��	\�	�ab�O�[ԃZ�m�.yo�^�ݫt�=��#�t��B
܅
�51n��)���O�{\j�
�U���Ӛ`����v�y����`MR��pkY�)�c��lI�Gh*C�fR�4��H՜�IY�(_Hv05i���Q�2��|����Ldun���	�I��P��!a��q�}gٙ��㨺�4D���+�#}�L��? )R5�r��QE�v�1mI��l�OyS�c$�S�Y0���^ �X�x|�ڣ(#c�j=b'pY7����0���pđ�_��qm!�7֟���(�6�@̋�W�6I{y'>��M
�`�
`�cm��?+��V~.Q�f`î�K�*�|�,�t<Y����y��Q�e���@�i��������n�A��зl�+�1��;��!�ݑirg��#Y�{ߙsC����TEРu��Ǡr=� ���x��`���(��z�0JO��B���	{#�C�A}�5;������@�ک��R�U���i7�-4̖�`������Ń�� Z��Jr{���ƘwBS��8�n��fO{}P�:z�e�8F,(7���ץ�N �U�b�s��Iz}�S�bZ���������`9�3��d�҅�Z���E�0k�]OQ�ӊ���83SS^��-��y㽝����p��Hk�ܰ�9��L~*�7�/zvP�XWW:���u��܈SogΨ"�e)��&�젱��(:�ͼ�N�Q/K�mcoiXv�E�T��;oW0$NSN����`���xo����ఏ%! yb.o����I���J�iv����s�J���ޞ������r_V�)�U�Y�3��j�<�.�"0���H�����q_��م�J	�����! ��zx�Z±/��vK'�E�c�z���/Q1|�o	�G�Q�$g�����ߢ����XmB-D��}��G���`���)Z:�_��`Z[�;�D���*��/~�����±5JQ�$�6{�����A)X	v���w0�h��z�S��$��!�70<CJO��$��O�8~�u����Vn�w��?n�B�h��[���nj��f����d��b�k��Ϝ�%ΔT~G;����9��:�_�O�E�UK�}-ǇN 	2-_�3��;��yG��v�,��:�|kRKs�e�U=굣~'I���4J��c���뵋��9^i��B̉���\�e=�U�}��������W%.���V�%d�E%�$5�8�־��q��7�T�l��k&	¤{Z������*^TX��V�A�~!f!�z>&*]��*Rq %x�!�܃�C��
V4��T^$y�l��~P?t�Cy�u�
P�֙:e�y�C�9�E禎g﨩�n�r�a$R�@��@���Zy�F��!Z�|�|��2�W��=ל�>�r>��Di�K��q�@���7�	P�c ����������!@��)ٵ]����N�˹�c�i磄�Ӛ�/}�e�ʰ:k�Mcn/<�g�53� 	HJ������VAG�*V.J�d��KﳳA�$Ҿ���2��o��&�u$]�Cσb(��W�#�;n���Ѻ�/��.���&��*�d�Gk}�F�%��p1W�Oى�kz����_/��N�H� ���� $���?�F}����Е��_���a�հ'pа0��Q3�=_�	�#\�z��l8����[ ���m;�#��E�AH�U�9�����pǏ��������T(9�h?��4d*H_PY�G�6	,�kss�ǌ�_~'�2p���Qv]\�f�Z��yބ%z�B�&js��B�❟����18�-XF%�.��=��l��_n�ˋl�y%���6B�Tsķd{�b�_�c��r.��3�Ǻ���+ZX4 �36��I�z}��^�%[4��
+�JPN����qZ$��70c#�H�Lۮ;�_��ƽw���JL�P-�D�$��"gy��Ӽ�V��7$y��D����as��G�����Y*5�=A9�G��c�a�yh�������x����#~ �)���1;:ۗSa���F﵇��\� GB��w<|�>��\�A�\�T��Q�����o�t�1���f�pz!7H�ć��^t_aD>��)�`Σ��N�����Qh�,.O��I����B���8��~�">��<.�X��/Wf��l'h���ٴ2�}�3�6z�O펉��(��sZ0c/0�� g��_�;9{{�Z��tr;[[�vv�W�R#����T'��y#��:���a�)����ͥ��RW_�޵{}��r� �+z����@��zg�Q����'sd�;��B:�	H����H�ߑ?��\HJ�9HPNt��h�Rx��^S:��t��t푒o��r����6"���<�^,��������]�C��=hx���D���}�q�Q���Z&��l�����3-d)U�d��q�˿�/wj�i&F�_�J7��q�"#	��j*�w��I����<N�L� c%B��OK1�����}M���c]�6i���V鷲�΂��ؘv�)-h{��j' FycϴT "+`˭iS��ԇt��] �QӚ�ː�(�%����<�Q־L�^�O	XQU������qa�EL]XX������S�lT�w�{�|7����P	;}�3��������P�)���4mk�7��q��eZ�B�u�'UN�Q�);�� 6(���JU�ƨ ����a�t�̑���&%xZ>We�Qρ���Z�0�͠[�c2c��LpZz,��h�P(J�}{�8�84����Euc",���r���#�C|&ƌ�x1�,�."Q54Ij�L����RD5�]����"��z:����!�h�`��m�}���v���R��,ed��iz$xU{��.�+� "#Kً�k��ס�Gۛf%�@�P0x�)�(�Kj�{u������c0#�����Yi�����H��s�%+��U�Z��ċ3�)z%���梪��o�~u�1!�C��@CdйN}��<��]��F!$�5C��p��s0���{�K�W���}'�q;�7hT�� ).e�A����I��B萐4$0�5�R6j�W����Y��Ou�&h1��N��3�C���w�mCw��
�M�����]��#����}�_	��*D���O�d�T�W��3�b�[�*���Nu8~�E	�Y�vs�KFgu�_�T��3hI:�,���%���5��w^h�����B6aא�js�;?Ƹ�3�JOz�$0���S)�?�v5��s8��c�b�~��x��9F��L&�1��ҽ��� �q��s�cY�Ҭ����:|�_�'5�Б��A��p����	�o������s�2a�%h�����br��]ה��`]2=R&y�^;e�8{�4��[Y�-���͸�9cb���0(�AD����y�خ���\A{�^b�*���pzs��?�v�m�,�&U�sRjc>����K'�1��>�p
����w�6�a�I�`I/K��i��wļ���,HO8+���X�B%L�y
�ʬ�r�F\	e1�K�h\�u3��DBm1�08�f�-�PNEZW�η�ޙ��P��6�`a'�#eu��L�v}@%�fA�������X4Po@���k��$��ح���ͥ����tVk��u���ȸ��pQ�VRǸBG+S\I���f8�)� c�
���J�P=q*_{h�G�+����+QGk�tftӏ��=BI]g���)%P�B�r�����fv���
�)T�c��p��x�u�� M��-�9�C*����n�    V����WG;�A3�}��x�yuBQ�-=66N4��Ȯ׺��o7�ʥPu3BU������uO�v8y��t�n�$�����dg7�2�g���HL�(�z�.�6��I�<�xz����a (q���)�Fص�.>ZA�W�' <euݴŶ��3z�jwA2�I{�D!�rr>�{܍o�Q�!o_uHE+	w L4�L�|���һ<U �y��T+�=o��Z�ǅ�@?�LJq�`��|^؈�QN��}T���e���e�L$گ��cCvT	J�z3�gJ��9(찠UQ ���'�~�L���ݤ�1��1go+I���%^�{R>z�ө�k��ؖ�Q�De�d�o��"�̙	�!�~Od5���/%/р�k:��h����W:�ź�����g�7
Uֵs�������6��1m3Ѡ/�r@]#��d��F�!/���Y�T�,�f���B��!F
0�N�u[��[�o��ώ�F�q�	9;ҩRT�Tb\>j-'�䡮���D�}�/��h���C��B�y4���'����+��O��hL�VFL� �@�tz����.^ٔNw`S�E�~ �B���yO��r��Ȝ�b/Lc���V3{�[�y	/a��M�@�W!�I��)�(>N}:���J�P���²�i�QmFV����F 2�B�Ґ���ם�Z���8��'M҄;���fyk?`��(�](u^(�N��arPL��:m��i����-���ᡘ@�b�ZkP;��6�cW9��/��o�<����/�c\���Wzy=�V8���-���ޚ�u�hEJiBJ;�e����D�H�E�fW]����ˬ(�j�0R��E?˽nܱ.k��T\�`5}jԶ����6S�)�k��%���*�!����Ҡ�!�0X �����1s�i��K�SM(˔I��e�������t�Z	�!��:L� j�Mi�����.�-����	F}�E�V�'���$}�%�7�U.�7A��M���՗X�<��hl�9��ߒF����/f���Ej�|PF��R��Y��I i�L��sY~e�������o�>dYh���o.�՚P9�k�����5p��G�v�P,S�z5�� �b��Zp����ഩ꾮�o�:�~ҿ�4 b'�t ���i�˨}����@��Q֖�%�C�o���u_�"�"� k�d`IcHV�TIu����+�D��	�s�N���vs�g�ghQ#˄#Er����v'���4䭱RMC�C��_l���6���G�Tw��5۲����e��Ē��G�%����yIw�x�ț(f+�+�r��Q�:bA.�֗������=�ї>�N��V��u��i�1L��Rwt�~1�x�a��*�)a�kGִ�7��G�u�Y!$%��Tb�(�
����N�^!r����yg�J�ޭ	�쏤cG�zc��� �{I��}J����0��l����W0�۵�&�n?�\�iu�0���Y��W���Ϲ�:��7Tr3�䃧����?x���~`�ߤg�B�o�Bg��zΪ7K�h�T#��]�������M�#:4��*���u,{��s,?[VR�< b8�C��p\�@�p&v��k��)��]b�bl���~ז径����d��r����3�ґ�Ε����)&*�k�RV�K��	��AF���9�De��@��ϲ��AX�H�c�K�%ޡ��V̪7<��X|D�kR���q}�D�3����*�o��9���SI�L:f�8�X��
�z#�3}mK9 ���Ĥ���Y��8��h�
v���^y����Y��:���Uވ�E(��=8���!6�3��a�&����4�L���j*��q���ؑA���a��)��ӫ���CuxIR���o/�*�g>	!8��DC^ s5��)S����A�_!�Ip������k���w�|S���khv�~�� N���+���� /u!�ԔY�0�&�-g���;w�"E�2>�b�dyJٽ˝�P�����`�̄J��Y�R�<�S�9*�Bu+$��	�%�t0ʳ���'؂D��¡��5y��/���r�//;Ҫao"��jzC��8�Y!o%FI��0��E����1�A����"G[�+y}�@b��i�{RVuB(۬�ڹΑ�A�#Y���A���H�9}�Z}���r9Ebi�s�_?"2Ė ʷ��37W�U<��qln�@��9|����d@��������r�p@:߂�q&.��:�a��yq���J�J��k+�I��,h��l4b)�j����ў���PA��_�9���Z��/�D��и���#��5<�l!BVՉ�o����OcUS.�0���
���3O2�"��3ո�*��!ЗvU�n�<�&�D���A�k���~��>��{�OoBQ=`c�
H_A/*C%�uaӳ�q�1a���l+myPo)J�ؐ���ӕ[������|ih�@����H��Q�+���F�Zы	�١;�Y/V�4,Lt�¤�zoO�}�sȕ�A$����)Gw麆�th�Ty~�ƒ���B���B��@�|���4�ڒ ��:5����N�{�*���O{�ޡ�c�,��J��̞�md4/� ,++Sf视)�X�W��y6�����Z����P^�C����Gf�/q��5O
�1�
HD~��;�����eatM/9�ǆ� ����z���]���������>��P���sr؎�|vď��h ����`�^�Gp)n4;�iS\-�
�Y�� }:{��3�љ����9�����m>2��0�w��O��$no�'ʉ>�Ϸ�8T�\�mE��>hpa*�0�3��>4��H�\����0�����4��Ɯ=�#��B�u��ۧ��2;�����%^V ��ò�� 8r�����������m�	�rp�������~N'�5�~�l<\��18ek�c@�b�tI���,VE�I5Hw�{/��Ir�x��LL�0eN	g��KLx`�x��F;'��Jm���F�Q�p���z��n
 �d��h�WryTgu�O�ܡ5|�2�U �XvI}���)D����f`B�u,���!qi?eZ�K�u�_HzPDtR:p_o�̣D��O"�T
�%��C��{Z�K�y	��@����lUI#���[j:�r�s��=9����O|=U��I��  �G�E�xB�&��ǻ�-*�P���R�8�7w,����*^��dJ�hC�^�ܩ��.]�ՠ���hB�H���J4����I�c��b����\B,�M�4o�q�Q��b���8U�uꓧ���y�n����]�\A��ȏ�v��u����q �yͅU�X\kS>]{#��р�v���a����s����=�1 GS����h/IIo�����j+��q���r�s�>��'�x�f�{.�b����Q�=9��DQ��^>gu�D���A����{������~@�,�,s���W$����Gˮ+�0A(�m��@�Ou)'�c@�ū!|i኏.G�_Ҹ��<3&H��j��/P�A~{�y�>3c ���G��σ�tuҚ�J_��+ ��&�/e�J�����~�>ԧe�
��Ԇ�@���\N�*,`w�v`ţm[)J]e!��fI�Z~��"����n�ò��2@؃�yE;�S_�hd��1��V(�i)E5�AF4�@R�Śe^��r��2�w����a�ώ�]th�I�OȰ��S��m9�Oo��������E���H�X����*N�\�w��" t�%a �
�Bq����s�Meq�����+yv擛b�z�:b�%��ʁ��ypRPEv��>c
4�|��on��$qf�.��c"�凌C�M8��XthU�jmƍU�-za))y�d`j Q,ȡ��.�.h��։�8�!��0�93���7I�ȁ�!l�}:ϔ��m����b� �&�$el�6��Co���]jb;�ĪYT�O�ӌ�Rq.ӌ<�KU�Hq���#�|�̶4��ưi%�C���9/�c�@}g����-��K������2�ʋ��l�    �����v!�x>�;�||�}1uR)��KiSZ[�>�O��i������x?�_��i��G��dg�FE=��;����ޟC
0Y8nu�T��<S���_�5j�ȁR���Q��[���"�H�)K\��J���8�p�~�����R̹�M���}�k��+I&X���D� �� xF\���ܜ=YU����J�"]\L���j_�	H�0� ]Px]zH���T]zʜ�<|��ں��/7�&!-�C C�TU(K�S���ߙ]�ejQ�����΄Һ��}�e2Kg����m�"v:%d=�XW\P�H�C~	/E�j��}}����طHԧ�p
�AC77W[�W?�i�ፈ�  	敜�Tmҥ����
H ���#b�%��'K(��_��D]�ams:甩 C|�4�^��d����Dc���2	㲁=��F>�I?��銶�A|_;�����&@Z`�0W[&6w�mw�#WA7��4�2᎞y�f?tk�� IΫ����Ts_W�hK*�1έ�0fgHNk�q�ls�[�\���<Ʊe)�!�y�|�+���{x~��%FPQ�%������M���]L���5?��l`�Hݭ.=�#��cSc������>���
���.��B��t��vĸLqt[3GrF��ho;36{���2S�����2G���c�OΙ)�T����
��ؤ�>�
�Y��]^cXS��#��qW�ǃKrb�L���1�s+�c�]6���I���Ape��Tǋ�'y���B�꼷0�����w{]H��.�Q=�2J��cؓ��?��>�'a�k渧V��؝h��������4q�
�hN2�*���v'W���R��\EP�3֚e?��o�w��@��S��s;mǥ�~vsM�|/���/� f� 2Cyrxx�0$1�!txAWj�G
w���2��,���jyv@D%��D�b�2����df㳞�Y���a�Jz�\sZ�t��aG�b9C��g�l�}&/�L���Fq4�H$� �(I�8Z<(�8k�? �܆�zO�w����%W]�ؤ����L "|�x���d:��W���*5��t���d �2u�P�A��r�B�O�C�;Ͳ]����P�A��@��'Mۓ��SF� �G"�	�������1�q
65�q0��b��7bw�q����z��H��ʿN�t��z��rc w=���Z�	W�T1������G�IUϊ���?SQx-l[]��R~H����zv���yL��Ar��E/A�����Y��ӳł�L,��$�����vldf�����Q�VC����c�Fk��r�����jǾ8%+}��GF���%�Ҏ�*�����,hH�|�9��G,�o��F������q��"_%4D'�B`Ӳ�( �phf{��ŀ�yc1��%�v��.R�C�����A����ԃI�:ȡj���q�Īz�<��i���/8�mZI�N�/��ES�O�QZ&{�����\$�\܉p���h*_`��������m�crw��*D�d����Y} E�&�/3�*��F�	)�\�u$�5�>�W�\��!�j!���LG���;�c�����1r�F0?Y��!���A�ϯF�l��ų�ei�׏��Ul�E1�2^��B�R?�A��U\Q\��&�yȸeq�m?/0GC�hm���Ė��(�H�ة;r�@i4'Eݴ�ޥ��#�6��z&�G�C�XP۬`ٖF�v}_�o�5��P>��M��R}����#r��.<Jh��JVw��i���Ԝ8N�����	����q������ev�K�#	���"�!�Ǻ�9�Gy+��MAw*B�MRo�I�Aw��P����������7�x��!�ut�k���.�ػݧM�G�1�5C	E'99Y4������ ���-*��!�<Vt~��t�G
��#�W�m�3�{��t�؏:���m[��e�(gMr��q�#Ǚ�Pl�3�n�eu�iԫf�i�S�12ݫs)�َX��Z��V���v=��6d�2�k�`<h�.��
���~��`�#�-���O�B��]Vy��'�����4���z�\�7���v�/h�LV��)DQ���!{��웙D��/\��A�	�I��g��*j��d�{���i�e�D���0���*'�鼺U��1��F��ٴ�l����筷;�s ����F`�"ʩqE��G�\� XV ��Q��J��.�L�+��]XH� e¢%�(���������J��B`�+��S&��o�)#o�l1���Ke�VCJ~�V)���wq��n�i�N�0a�y�8�S��i�s`�vmF����O�8� {��껏����N�k�4��99Y)w�Ŭ,;��G�!�ߝ����y{�t�.��ɑ��ؽ5~%[,~�F&�� ��݆#1��O�����ӓ�6���BIT��8��cܢ!7y����'J��uCďŴ�bE��Fr�-ա�A���}r�/�gR���V��b ����S|��X:u[�����Q5�)�|��(��;l�pݤ�Z���S<;j��)�������F���S�H$iz@o�m���UD��O�ɡ��9�����6�xeS;�+��>���'�ɠ5X�RBr���B�҇���М��n�Y{Uh��}� +�k�"y�Z$�����4�e����~�9�sh���:���ľ��k#�6�h�d�R�y乛k�%�w���c��'��٠��w�&���i�2���t��ym�0�:H��V�Q|�B��*0��Rt�o	���I�Ť��q�,<3��RT]j�e�h�]w@�Ac4�m�06�P�g��˃���Jϕ{q��k9��}�-�aZ���VgT��5�̾�;��"ַ���~*|�B.T��?��*��3����9�`.
ܧ�'΁Qvn<�� E��-w_��!7�,L*�^02k7H�(,�w��Az"��v������6ܶ�S~tu��*�Z��I���!�e?�H0�^HA��1:cUCct%@�O��/`;DgL��tH�6�+ʑ^jO�6t=�\=�\�vłC2��$�����+�����ǰ�}�=,����x���Ŵ�M�N@k�X��PO\y�Nw���C� ԗh�U��У{�gu�n��#mwQyitN�Jy'�L�\D`F´�9F�q�g��?7(~dw�,aG�t���]@.�@�N���r��8a���
�8�BP�Vs8m���x��
�����wXB��i2xu1t2=�޻�^�2�AR�D��Lg��a�^�r��M�}H�H�VI��ڰ��zv߼���8�(!��`���M~�ہR2wP�r\�8"G��	U�'m.ه��Xh�NƻX��	S��zZ'^47�M�
ϼ|p�HQ5{oG(�����A��Z�XS��r����v��%t���Qj\c����{��"�r^�@K��X=������Ys\�0�
�T��O�;��wv��`���$ĕ�d38��ݳ7F�=�r,M#c�����.j��O'�k)Tj�%䚠���'Y�lש�s�,B��ɱh�ӭy�Ll�#'��Ҫ��
\j�;��k�0>u�4��uP-0R�e�Q�����n1��s�>��"b楳HK��<����7N�͹�� �[��:�,��X��2��_�N��'R[�;��H�l��[N�iQ0#�B�c�0�6���r���'Ak�ضe}��eYQ�z/ے�!���}'�ZmK�	�*E�r	�Eq�4N�O���ۣ${�y]��T�Ӵ{��\%+甬JaBcI�8�ܴ�n�|��9w��:[l}���R�Sn9�=)�ѕj�U?Qˋw*��%Qw������z��xas0�1����(_���+����A����9+S��G��'u�dB^ 0Z0���U�<u��Pe��*U:�)�B�r�O2��.ᨐ8n�jŝe��=�^�_��8	�n6p�2�tym�4>��"?�p�q�0���,.�䇹7�6�
�z,�`V�Em%��b�q�5}��Q��A�T��ǎ5��    �A�p��#*��T�dT�&i���ˊ��y��d�@$�H�խ{\h�X ��d��E��:"�v�O�",Ւ�[�*�t�p�I �#=T�E��<;�ǨB DP�`�doZʪ�o�Y�|T ���<�L���K��݋_�Ky��/�*��@LHV_�E1���;'3���L�.�c�Gǥ��&Ò�JH���Zs�aps4�p=�n� wy�t'c~2Tio wWh���Ht"��p#d:�V5��,WVp��>���ܥXc!��� ���]b�7���g��Y��Ȏ ��r�؎\�P����ͮ��q�ָ<��Vj��n�|���Uve���:���bK���d�눪t�{.��i @�#pN��b��λ���ZY7	x������6	���T�8AW[o�V�(��+Fd;!s��ԲOs[��d�&��0�krv�F^5V�k-�C�����+GK�eQԽ�X�]�~]�ן�A8Hߧ���suأ�$f:��8s�T��v�����09&՚����4*���b�bn���oh�X�J�hI��D9*NI!R�_���YD��5j��JI�]6�z��H�">���NyJp2�NH����%�v`��0:g�P��'�GfÝ?���X>��H�hַ|9(P{.CwH�m3�]��>7L	�\�v�����4%�O���[��m<��4:�]�9WI��Ρ���0���+�L�I��>d���\�mF��Ezd��7��<gf�D��f
]���m��M���@}�G�6��(Ws/��o|�`����){�M��C��Z�<Y��-��9#���K�Վ�?�J�*��N�� Na�v K&
7=0y棕y�l.�_ Ґ��v���61����JoI8���DVn���Ѥ����0�e`ɣ�n�!�I�����yV�a�%��E �3ENj~�=r��+>�Mc��3fY�1=��a�3sc�2�6��[(���|M��EX����+sGE5�\)kIvc��������H��zK��e���{�bc���Zm��H=��,�R�����C�U>��G�н\��>�+I2�z��M�8ȔދK	�Jx�x��v@��$���B�,w�_:��eF$,��X��Q9���,nv�N�_G��'���\�ff����}��	n�!H�C�:�r'��ÇJ	�K�A�V�g��Z��N��t���|�u���-�ޏ���.�[n ?ܮqNOL`���<�~R�ΐ�t5�������Z�΋�*�Z�Z>�yo���',c<B/���\nd}�_�{��(�Zح�i-cR�$�� ���eU��?[X���	i��U�9n2ٞ��>�P*�L�Q�Ƴ�T��d�u'1�.g����U������um��)�I�!-ßstP1@D��͘F�bgS:�n��G�
?��m��:p�#a��R�5e;���fAGI�_i���6�lS=e�/:�D2U_�`�3b�����fj9�J�o�pZ'�� c�L\����eW}�i��(1�Fi�c�����f�����`��6H�M��@y��9c�2�)@����B������n���ޢ�0L�հʑrJu�����WY9�X�L]Չ�lv��ׯ��T��9�	b�J���^�u�)�s턶^�:c|Qs�	�b-��E^���X���/��|�f�N���� �JdBm$	J �K�)9jŷ%ݝ��ٕF�'=��ښ#=��>ebl�:�j�o����u���#rT�G� �Z������N�=����4Þ��y��C�*V]�a���ܝ��S�?U+b'�A����o5��B�Y��PxБg(�D���w.�H?��!hc!��^ ��\������G�*Q;��t�%���&N�J��ؖ g�d�t�#������	���h��q��+����@�І�@�0��Gs�����x���<��6P����_�El���<�&���184���LBH�j�!�[�0�B� ����m�n��b��A��(:R�]������ƒ�w���C�J�S]ۡ8%"���䷸�d��`��~�N6�P�X��M�Z�;!o���zA/�2��(����i������c���j�M�e�x����b�d��:�e��Ja:�xx�ϵF��xL�pr�O��,�v�t��h�����l�8�q*��/��1�����6Z��}$�ʘ�ð�>��/0b9�xo.��";r =��MMt0ΫP1��0л�'$����X��LO��黻+9���r&'��B�Y�Z��)֙��`cE�d.�/ �����	�u#�g�t�]�Ӄ)�rN��js^l����T��|����L��ð#mgH��[��E5��>�:�ug��(��{�څUJ�fl�˪�S��s��Ժn��S�p��~I��$0����5�c��IDu�.^����(%�|�Uܻ���X�&��DTA4l�x;�zAEBP	����,�Sɿۓ.O�Z���X���tb��#f���ݱ�=,��C�z���Н�H��Avw����;�o��b�w1,ڏ��Pt*�JQ6J�50n}*���T�(<��؅#	h]xz5��%aCKc$�<2�1���q
-p�*u�%9�殼skw�ƌ��6��.?�m��Lx�7�����@6WɡK:�#��萊Y	��d1�ʳ�I&���M�8��:�� ߠ���Ig�k�;][yeZ_��V����B�Y.P�?��BŇ{vM��l���S�s�%�E9J�>n@���6��g���Z��/�?��V-2��4$�N/q���ģ�'�o�/_ ��y>���ǖB�U�Q��r|��`�dN��m=e�~��D�-C4`��I>���J.����IU��3jmPWJsT���e��A�	 K�V0��Oյ�s�_�CԴ�_A��Yn�)�~˅ջ*%�>ah�3��[ u��}��5�S0�F�)H�X���kp���wl�kIA�Mw%���g�}�}_��������؀������on�PⵆA���gf�5+�I/��GΠ�6�=I�Hm�>E��c�~u�~��?<n0��J��7t���Q(������<��C]�x�`	CS������~�+.�(��2AK�h����W?_�r�[%����g`gt��H�.�5�/�n 
>��J˄k�	cƻv��w��j������l��d���|)���g �OX�W�k2s/�m��6�rA6˅����E�[t�p�]��;�0�
��������"Evc���Dfm9�&��b��Q�-�K	NW�f dـ���Oh���\_uw����P���o�>��'�EjO�y�.q?3��]G�n^e�*a:��<��Ɓ�b��>w��nέ/�f����;u����E7�]o��J�i���1��2��w8q��_02+��'���FH2���q��O��̆�H��������q~)NPm/̔A[3�� z`��'4yO!&}:���3v}�>�X�E������)��6YN���b���E9�_�2��(���N�!��j��T�30�	jli�����{�~�#η��b�jUW%�{��[��پ�X�Y+��W����)_\�t
��!�(&Kکj�Vh}�W2��P����g�m%gQa���s��b��#�\��`f�7����
�ި��	W��^��i�>*Ma����D: �<Q���ʹV�٘ZQ&��x@yؚ�v>|d�h���*nc����z��Ⓧ��e�R�wl[����I������t�9�Q�(�Ą�Z���g��#��")$�͕]�/.:¹8Y�����
��l���sH�ݺ���#J�����ѿ��h���{
;	\�HL��,���"�����X?��pR��BMN�-h/�]8![e;_�������hAK�o0�1ևz��ɩdP����\Xp��vG;C�99���r6J���
q�<�ʙ�Xy��vXZxcC釋�t��v��:4��+LF���C�]�>e6�'�2�� S  �,Z��h�|!�=xWPP�zU���6X��o�H��េ��9���|�+VY��y��ك���Y���ӈ)�?�j��V�w���(_�apPgHe�JBV�:����!%Ø74�l}ݼ��dޠ�+x�H�Ҏ ��L���l"j�m��[�\]��#�
c򲊘tǎkˆx~�w��3`�{���D#g�G�q1f�L����̈́�'~��22� �`�+:�jꦜ��O�n��U��b:d&�pN�b㭀D��K�a���6`��~�S�lD=���8����,d���p��A�sI+8XϬ�}�K����KHG�fr1¬��d]>���@�,q���f =�k���*]G,m�X��K�>��3��1y�l4+����@����N�BIP�s��ƿg�t�?�e�ꦄg���.u��%1�,h#��NA�H�z��W�H�� ��@�{�̫��n_�(]�3��Ərt�&�ke��<���XC:�8 &Hc8������.��0�/纁�4w�2�6jZK�kp2Z�o���Kp�e���~;����Q�0pG��;�8�/�^ǯ�������?�,��     