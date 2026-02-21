import { type ComponentProps, type ReactNode, useRef } from 'react';
import { Button, type Flex, Input, Section, Stack } from 'tgui-core/components';

type TabbedMenuProps = {
  categoryEntries: [string, ReactNode[]][] | [string, React.JSX.Element][];
  contentProps?: ComponentProps<typeof Flex>;
  searchText?: string;
  setSearchText?: (text: string) => void;
  extra?: ReactNode;
};

export function TabbedMenu(props: TabbedMenuProps) {
  const sectionRef = useRef<HTMLDivElement>(null);
  const categoryRefs = useRef<Record<string, HTMLDivElement | null>>({});

  // const pageContents = (
  //   <Stack vertical>
  //     {this.props.categoryEntries.map(([category, children]) => {
  //       return (
  //         <Stack.Item key={category} innerRef={this.getCategoryRef(category)}>
  //           <Section fill title={category}>
  //             {children}
  //           </Section>
  //         </Stack.Item>
  //       );
  //     })}
  //   </Stack>
  // );

  return (
    <Stack height="100%">
      <Stack.Item>
        <Section height="100%">
          <Stack vertical width="150px">
            {/* !!props.setSearchText && ( */}
            <Stack.Item>
              <Input
                fluid
                height="2em"
                fontSize="1.2em"
                placeholder="Search..."
                value={props.searchText}
                // eslint-disable-next-line react/jsx-handler-names
                onChange={props.setSearchText}
              />
            </Stack.Item>
            {/* ); */}
            <Stack.Divider />
            {props.categoryEntries.map(([category, children]) => (
              <Stack.Item key={category} grow basis="content">
                <Button
                  align="center"
                  fontSize="1.2em"
                  fluid
                  disabled={children.length === 0}
                  onClick={() => {
                    const offsetTop = categoryRefs.current[category]?.offsetTop;
                    if (offsetTop === undefined) {
                      return;
                    }

                    const currentSection = sectionRef.current;
                    if (!currentSection) {
                      return;
                    }

                    currentSection.scrollTop = offsetTop;
                  }}
                >
                  {category}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item
        grow
        ref={sectionRef}
        position="relative"
        overflowY="scroll"
        {...props.contentProps}
      >
        <Stack vertical fill px={2}>
          {props.categoryEntries.map(([category, children]) => {
            if (children.length === 0) return null;
            return (
              <div
                key={category}
                ref={(ref) => {
                  categoryRefs.current[category] = ref;
                }}
              >
                <Section fill title={category}>
                  {children}
                </Section>
              </div>
            );
          })}
        </Stack>
      </Stack.Item>
    </Stack>
  );
}
