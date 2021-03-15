PGDMP     8            
        y            prisma    12.6    12.6 -    C           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            D           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            E           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            F           1262    16431    prisma    DATABASE     �   CREATE DATABASE prisma WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Colombia.1252' LC_CTYPE = 'Spanish_Colombia.1252';
    DROP DATABASE prisma;
                postgres    false                        3079    24820 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            G           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    2            �            1259    24707    Permissions    TABLE     �   CREATE TABLE public."Permissions" (
    id smallint NOT NULL,
    name character varying(50),
    methodclass character varying(255)
);
 !   DROP TABLE public."Permissions";
       public         heap    postgres    false            �            1259    24647    Post    TABLE     �   CREATE TABLE public."Post" (
    "authorId" integer,
    content text,
    id integer NOT NULL,
    published boolean DEFAULT false NOT NULL,
    title text NOT NULL
);
    DROP TABLE public."Post";
       public         heap    postgres    false            �            1259    24645    Post_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Post_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public."Post_id_seq";
       public          postgres    false    206            H           0    0    Post_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public."Post_id_seq" OWNED BY public."Post".id;
          public          postgres    false    205            �            1259    24752    Roles    TABLE     d   CREATE TABLE public."Roles" (
    id smallint NOT NULL,
    role character varying(100) NOT NULL
);
    DROP TABLE public."Roles";
       public         heap    postgres    false            �            1259    24775    Roles_permissions    TABLE     �   CREATE TABLE public."Roles_permissions" (
    id smallint NOT NULL,
    role_id smallint NOT NULL,
    permission_id smallint DEFAULT 1 NOT NULL,
    permissions character varying(255) NOT NULL
);
 '   DROP TABLE public."Roles_permissions";
       public         heap    postgres    false            �            1259    24636    User    TABLE     �   CREATE TABLE public."User" (
    id integer NOT NULL,
    name text,
    email text NOT NULL,
    password text,
    token text,
    salt text,
    role_id smallint NOT NULL
);
    DROP TABLE public."User";
       public         heap    postgres    false            �            1259    24634    User_id_seq    SEQUENCE     �   CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public."User_id_seq";
       public          postgres    false    204            I           0    0    User_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;
          public          postgres    false    203            �            1259    24705    modules_id_seq    SEQUENCE     �   CREATE SEQUENCE public.modules_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.modules_id_seq;
       public          postgres    false    208            J           0    0    modules_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.modules_id_seq OWNED BY public."Permissions".id;
          public          postgres    false    207            �            1259    24750    roles_id_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    210            K           0    0    roles_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.roles_id_seq OWNED BY public."Roles".id;
          public          postgres    false    209            �            1259    24773    roles_permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_permissions_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.roles_permissions_id_seq;
       public          postgres    false    212            L           0    0    roles_permissions_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.roles_permissions_id_seq OWNED BY public."Roles_permissions".id;
          public          postgres    false    211            �
           2604    24710    Permissions id    DEFAULT     n   ALTER TABLE ONLY public."Permissions" ALTER COLUMN id SET DEFAULT nextval('public.modules_id_seq'::regclass);
 ?   ALTER TABLE public."Permissions" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    208    207    208            �
           2604    24650    Post id    DEFAULT     f   ALTER TABLE ONLY public."Post" ALTER COLUMN id SET DEFAULT nextval('public."Post_id_seq"'::regclass);
 8   ALTER TABLE public."Post" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    206    206            �
           2604    24755    Roles id    DEFAULT     f   ALTER TABLE ONLY public."Roles" ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 9   ALTER TABLE public."Roles" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    210    210            �
           2604    24778    Roles_permissions id    DEFAULT     ~   ALTER TABLE ONLY public."Roles_permissions" ALTER COLUMN id SET DEFAULT nextval('public.roles_permissions_id_seq'::regclass);
 E   ALTER TABLE public."Roles_permissions" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    211    212            �
           2604    24639    User id    DEFAULT     f   ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);
 8   ALTER TABLE public."User" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    204    204            <          0    24707    Permissions 
   TABLE DATA           >   COPY public."Permissions" (id, name, methodclass) FROM stdin;
    public          postgres    false    208   _0       :          0    24647    Post 
   TABLE DATA           K   COPY public."Post" ("authorId", content, id, published, title) FROM stdin;
    public          postgres    false    206   1       >          0    24752    Roles 
   TABLE DATA           +   COPY public."Roles" (id, role) FROM stdin;
    public          postgres    false    210   N1       @          0    24775    Roles_permissions 
   TABLE DATA           V   COPY public."Roles_permissions" (id, role_id, permission_id, permissions) FROM stdin;
    public          postgres    false    212   �1       8          0    24636    User 
   TABLE DATA           Q   COPY public."User" (id, name, email, password, token, salt, role_id) FROM stdin;
    public          postgres    false    204   2       M           0    0    Post_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public."Post_id_seq"', 1, true);
          public          postgres    false    205            N           0    0    User_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public."User_id_seq"', 12, true);
          public          postgres    false    203            O           0    0    modules_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.modules_id_seq', 4, true);
          public          postgres    false    207            P           0    0    roles_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.roles_id_seq', 3, true);
          public          postgres    false    209            Q           0    0    roles_permissions_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.roles_permissions_id_seq', 5, true);
          public          postgres    false    211            �
           2606    24656    Post Post_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_pkey" PRIMARY KEY (id);
 <   ALTER TABLE ONLY public."Post" DROP CONSTRAINT "Post_pkey";
       public            postgres    false    206            �
           2606    24644    User User_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);
 <   ALTER TABLE ONLY public."User" DROP CONSTRAINT "User_pkey";
       public            postgres    false    204            �
           2606    24715    Permissions modules_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."Permissions"
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public."Permissions" DROP CONSTRAINT modules_pkey;
       public            postgres    false    208            �
           2606    24781 (   Roles_permissions roles_permissions_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."Roles_permissions"
    ADD CONSTRAINT roles_permissions_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public."Roles_permissions" DROP CONSTRAINT roles_permissions_pkey;
       public            postgres    false    212            �
           2606    24757    Roles roles_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public."Roles"
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public."Roles" DROP CONSTRAINT roles_pkey;
       public            postgres    false    210            �
           2606    24658    Post Post_authorId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 E   ALTER TABLE ONLY public."Post" DROP CONSTRAINT "Post_authorId_fkey";
       public          postgres    false    2732    204    206            �
           2606    24797 "   Roles_permissions fk_permission_id    FK CONSTRAINT     �   ALTER TABLE ONLY public."Roles_permissions"
    ADD CONSTRAINT fk_permission_id FOREIGN KEY (permission_id) REFERENCES public."Permissions"(id);
 N   ALTER TABLE ONLY public."Roles_permissions" DROP CONSTRAINT fk_permission_id;
       public          postgres    false    208    212    2736            �
           2606    24787    Roles_permissions fk_role_id    FK CONSTRAINT        ALTER TABLE ONLY public."Roles_permissions"
    ADD CONSTRAINT fk_role_id FOREIGN KEY (role_id) REFERENCES public."Roles"(id);
 H   ALTER TABLE ONLY public."Roles_permissions" DROP CONSTRAINT fk_role_id;
       public          postgres    false    212    210    2738            �
           2606    24807    User fk_role_id    FK CONSTRAINT     r   ALTER TABLE ONLY public."User"
    ADD CONSTRAINT fk_role_id FOREIGN KEY (role_id) REFERENCES public."Roles"(id);
 ;   ALTER TABLE ONLY public."User" DROP CONSTRAINT fk_role_id;
       public          postgres    false    210    204    2738            <   �   x�]��
�0E��gd-��ueB)tU�����Iɤ�obCQWs�<s��P�=�E��%�Ϋ�
�4�R<�J��2/w2<ƤAH��GQ���/��"�5o�������q���$���\@䶣4ϊ�{l[������Y�֧?���^J�2�\      :   /   x�3��+M-�WH��+I��L��4�L�9���4'_!$����� &�d      >   .   x�3�LL����2�L��M-J�L��2���+K�+I,������� �o      @   z   x�-�=�0��9>F�p�V]�X��!4�G� �����O�omjS����ۙ�ˮȟ������Z/Z��'t����<��6;A%�FZO�'L�(S��G{������T*&� p��5�      8   {  x�}�Ɏ�P��5>E/j�(� �������2���O�$�tL4�;99���n!7�[SCyݒ��>;pK[�q}����X	;	^�:J�+
��DH��D�{d�E�s���=���t���!t�A^�G7�l����y�"P�x���Q{l�ҫՓY*�I':������gOS���mVP"<�*s}����N,�/|��W�������8N~�9��n�j�ס�:LKWm֙�;E�x����y|�E�^u������
�����T�.�t=	���}u��|]�=�	o�"*��'�}?�䢓�N��<\�B���ߵ�r�p��ȁ�\�ɓ�>L���X3i�<޶�'�}?�E�-��Uos|�̳��_ZZ��໘b�\P^y+����7θ�OtE�Z�O��~֩E��z�űST��]�:ٍ�!&��M�H�x)fei�p��lM��<��{h�B�;d�W����F6���p��
�ol��4!Y��c���"1��dTR�(Vx�t��G!�%�!!:�Z������}F����Qr97���������ǚ{uW{h��1���� �ͨ�2o���̂yA�%iO�'��*$q�H�}V�ƙ�@��PQ�	�����7�Z�� tcrZ     