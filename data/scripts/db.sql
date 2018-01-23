-- ----------------------------
--  Table structure for map_places
-- ----------------------------
DROP TABLE IF EXISTS "public"."place";
CREATE TABLE "public"."place" (
	"id" int8 NOT NULL DEFAULT nextval('id_seq'::regclass),
	"arcgisid" int4 NOT NULL DEFAULT nextval('arcgisid_seq'::regclass),
	"osmid" int8,
	"sourceid" varchar COLLATE "default",
	"render_nm" varchar COLLATE "default",
	"render_nm_en" varchar COLLATE "default",
    "render_nm_cn" varchar COLLATE "default",
	"render_nm_tw" varchar COLLATE "default",
    "render_nm_hk" varchar COLLATE "default",
    "render_nm_in" varchar COLLATE "default",
    "render_icon" varchar DEFAULT 'default'::character varying COLLATE "default",
    "render_from" int2,
	"render_to" int2,
	"search_nm" varchar(255) COLLATE "default",
	"search_nm_cn" varchar(255) COLLATE "default",
	"search_nm_en" varchar(255) COLLATE "default",
	"search_nm_tw" varchar(255) COLLATE "default",
    "search_nm_hk" varchar(255) COLLATE "default",
    "search_nm_id" varchar(255) COLLATE "default",
	"zone" varchar COLLATE "default",
    "zone_nm" varchar COLLATE "default",
	"population" int4,
	"capital" bool,
	"is_capital" bool,
	"admin_level" int4,
    "admin_type" int4,
	"scalerank" int4,
	"geometry" "public"."geometry",
    "geometry_area" "public"."geometry",
	"is_rendered" bool,
	"is_searched" bool,
    "is_delete" bool,
	"weight" int8,
	"timestamp" timestamp(6) NULL,
    "update_time" timestamp(6) NULL,
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."vector_gullmap_places" OWNER TO "postgres";

-- ----------------------------
--  Indexes structure for table places
-- ----------------------------
CREATE INDEX  "place_idx" ON "public"."vector_gullmap_places" USING btree(id ASC NULLS LAST);
CREATE INDEX  "place_geom_idx" ON "public"."vector_gullmap_places" USING gist(geometry);
CREATE INDEX  "place_geom_area_idx" ON "public"."vector_gullmap_places" USING gist(geometry_area);
