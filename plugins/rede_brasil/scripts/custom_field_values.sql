PGDMP     #                     t         +   noosfero_rede_brasil_pid_import_development    9.3.10    9.3.10 
    	           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �            1259    21944    custom_field_values    TABLE     �  CREATE TABLE custom_field_values (
    id integer NOT NULL,
    customized_type character varying DEFAULT ''::character varying NOT NULL,
    customized_id integer DEFAULT 0 NOT NULL,
    public boolean DEFAULT false NOT NULL,
    custom_field_id integer DEFAULT 0 NOT NULL,
    value text DEFAULT ''::text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
 '   DROP TABLE public.custom_field_values;
       public         j    false            �            1259    21942    custom_field_values_id_seq    SEQUENCE     |   CREATE SEQUENCE custom_field_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.custom_field_values_id_seq;
       public       j    false    198            	           0    0    custom_field_values_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE custom_field_values_id_seq OWNED BY custom_field_values.id;
            public       j    false    197            �           2604    21947    id    DEFAULT     r   ALTER TABLE ONLY custom_field_values ALTER COLUMN id SET DEFAULT nextval('custom_field_values_id_seq'::regclass);
 E   ALTER TABLE public.custom_field_values ALTER COLUMN id DROP DEFAULT;
       public       j    false    198    197    198            �          0    21944    custom_field_values 
   TABLE DATA                     public       j    false    198   6       	           0    0    custom_field_values_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('custom_field_values_id_seq', 22, true);
            public       j    false    197            �           2606    21957    custom_field_values_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY custom_field_values
    ADD CONSTRAINT custom_field_values_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.custom_field_values DROP CONSTRAINT custom_field_values_pkey;
       public         j    false    198    198            �           1259    21958    index_custom_field_values    INDEX     �   CREATE UNIQUE INDEX index_custom_field_values ON custom_field_values USING btree (customized_type, customized_id, custom_field_id);
 -   DROP INDEX public.index_custom_field_values;
       public         j    false    198    198    198            �   �  x���KN#1�}N�]) W�+f�"�L`�Z�Ѵ�!R�q�\l�n�:UM�"�r�.g�X�=<����z=����˪�۷���=�;�|���n�.`����ͪi��L��ZU���)���b^����QA�vpm�F�mI�L��d �py��f}xo���m��w��3�.x��y�O���R��W���:��Tౄ'��һ$Hq$aH�!iK�P ����݌>"a �"�tY�T� ��h���E;�JT+�q
�h�RR���%r_� ��%O5�4��/rp@g�AQR���#�s��L ?�J�5�a��>�0�@��ђ׵���MS�3����,��A=��N�o'S�.�(�����@
��']*P.�~{8�D7L��kS����8�S!b}�AE{I���=w�!�~��
Z�>'���b���A>�gA �����É�v��h�ݹ�Z>�1�����     