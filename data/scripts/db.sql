create database coxosm template template_postgis;
create extension hstore;

-- ----------------------------
--  Table structure for place
-- ----------------------------
DROP TABLE IF EXISTS "public"."place";
CREATE TABLE "public"."place" (
    "id" int8  PRIMARY KEY,
    "arcgisid" int4,
    "osmid" int8,
    "pid" int8,
    "sourceid" varchar COLLATE "default",
    "name" varchar(255) COLLATE "default",
    "name_cn" varchar(255) COLLATE "default",
    "name_en" varchar(255) COLLATE "default",
    "name_other" varchar(255) COLLATE "default",
    "zone" varchar(255) COLLATE "default",
    "zone_name" varchar(255) COLLATE "default",
    "seo_title_en" varchar(255) COLLATE "default",
    "seo_desc_en" text COLLATE "default",
    "seo_title_cn" varchar(255) COLLATE "default",
    "seo_desc_cn" text COLLATE "default",
    "seo_title_other" varchar(255) COLLATE "default",
    "seo_desc_other" text COLLATE "default",
    "desc_en" text COLLATE "default",
    "desc_cn" text COLLATE "default",
    "desc_other" text COLLATE "default",
    "population" int4,
    "capital" bool,
    "is_capital" bool,
    "admin_level" int4,
    "admin_type" int4,
    "geometry" "public"."geometry",
    "is_delete" bool,
    "weight" int8,
    "timestamp" timestamp(6) NULL,
    "update_timestamp" timestamp(6) NULL 
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."place" OWNER TO "postgres";

CREATE SEQUENCE global_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE SEQUENCE arcgis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;    
  
alter table place alter column id set default nextval('global_id_seq');
alter table place alter column arcgisid set default nextval('arcgis_id_seq');

-- ----------------------------
--  Indexes structure for table places
-- ----------------------------
CREATE INDEX  "place_idx" ON "public"."place" USING btree(id ASC NULLS LAST);
CREATE INDEX  "place_geom_idx" ON "public"."place" USING gist(geometry);

CREATE INDEX ON ON "public"."place"
USING btree (st_geohash(st_transform(st_setsrid(box2d(geometry)::geometry, 3857), 4326)));